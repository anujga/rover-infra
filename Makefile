.PHONY: docker-base
docker-base:
	docker build -f base.Dockerfile . -t anujgarg2004/pytorch-24.10-py3:$(tag)