.PHONY: run
run:
	uv run python -m pytest bench.py \
		--benchmark-group-by=func \
		--benchmark-autosave \
		--benchmark-name=short \
		--benchmark-columns=mean,stddev,OPS \
		--benchmark-json=results.json