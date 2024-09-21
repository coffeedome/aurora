SHELL := /bin/bash

.PHONY: build_resume_api all

build_resume_api:
	# Group commands together so `cd` works across all of them
	cd lambdas/resume_api && \
	pip install -r requirements.txt && \
	cd .. && \
	zip -r resume_api.zip resume_api && \
	cp resume_api.zip ../api/