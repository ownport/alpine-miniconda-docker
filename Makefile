build-image:
	docker build -t ownport/miniconda:4.4.10 .

run-container:
	docker run -ti --rm --name miniconda \
		-v $(shell pwd):/data \
		ownport/miniconda:4.4.10 \
		/bin/bash

