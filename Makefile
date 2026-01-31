.PHONY: help install install-dev test lint format clean build upload upload-test

help:
	@echo "AutoParallel Development Commands"
	@echo "=================================="
	@echo "make install       - Install package in development mode"
	@echo "make install-dev   - Install with dev dependencies"
	@echo "make test          - Run tests"
	@echo "make lint          - Run linters (ruff, mypy)"
	@echo "make format        - Format code with black"
	@echo "make clean         - Remove build artifacts"
	@echo "make build         - Build distribution packages"
	@echo "make upload-test   - Upload to Test PyPI"
	@echo "make upload        - Upload to PyPI"
	@echo "make all           - Install, format, lint, test"

install:
	pip install -e .

install-dev:
	pip install -e ".[dev]"

test:
	pytest -v

test-cov:
	pytest --cov=autoparallel --cov-report=html --cov-report=term

lint:
	ruff check src/
	mypy src/

format:
	black src/ tests/
	ruff check --fix src/

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	rm -rf src/*.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type d -name .pytest_cache -exec rm -rf {} +
	find . -type d -name .mypy_cache -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf htmlcov/
	rm -rf .coverage

build: clean
	python -m build

upload-test: build
	twine upload --repository testpypi dist/*

upload: build
	twine upload dist/*

all: install-dev format lint test