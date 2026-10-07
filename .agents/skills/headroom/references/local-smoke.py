import copy
import json
import os

# Keep this synthetic library trial local and avoid persistent runtime state.
for variable, value in {
    "HEADROOM_BEACON": "off",
    "DO_NOT_TRACK": "1",
    "HEADROOM_UPDATE_CHECK": "off",
    "HEADROOM_CCR_BACKEND": "memory",
    "LITELLM_LOCAL_MODEL_COST_MAP": "True",
}.items():
    os.environ[variable] = value

import tiktoken

from headroom import CompressConfig, compress


def main() -> None:
    # Fail if the real vocabulary is unavailable, rather than report estimates.
    tiktoken.get_encoding("o200k_base")
    rows = [
        {"id": i, "service": "example", "status": "healthy", "latency_ms": 10}
        for i in range(1000)
    ]
    rows[517] = {
        "id": 517,
        "service": "example",
        "status": "failed",
        "latency_ms": 9500,
        "error": "SYNTHETIC_OUTLIER_517",
    }
    messages = [
        {"role": "system", "content": "Preserve error evidence. Never invent results."},
        {"role": "user", "content": "Inspect the synthetic service records."},
        {
            "role": "assistant",
            "content": None,
            "tool_calls": [{
                "id": "records",
                "type": "function",
                "function": {"name": "get_records", "arguments": "{}"},
            }],
        },
        {"role": "tool", "tool_call_id": "records", "content": json.dumps(rows)},
        {"role": "assistant", "content": "The records are available."},
        {"role": "user", "content": "Keep the rare failure for diagnosis."},
        {"role": "assistant", "content": "I will inspect the error evidence."},
        {"role": "user", "content": "Report the failing record's identifier."},
    ]
    original = copy.deepcopy(messages)
    result = compress(
        messages,
        model="gpt-4o",
        config=CompressConfig(
            kompress_model="disabled",
            compress_system_messages=False,
            compress_user_messages=False,
            protect_recent=4,
        ),
    )
    assert result.tokens_saved > 0, "Expected a smaller synthetic tool payload"
    assert result.messages[0] == original[0], "System instructions changed"
    assert result.messages[-4:] == original[-4:], "Recent context changed"
    assert "SYNTHETIC_OUTLIER_517" in json.dumps(result.messages), "Rare failure lost"
    assert messages == original, "Caller-owned input was mutated"
    print(json.dumps({
        "tokens_before": result.tokens_before,
        "tokens_after": result.tokens_after,
        "tokens_saved": result.tokens_saved,
        "checks": "system and recent context unchanged; rare failure retained; input unchanged",
        "transforms": result.transforms_applied,
    }, indent=2))


if __name__ == "__main__":
    main()
