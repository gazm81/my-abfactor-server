.PHONY: build run stop clean logs shell download-server lint

# Build the Docker image
build:
	docker build -t abfactor-server .

# Run the server using docker compose
run:
	docker compose up -d

# Stop the server
stop:
	docker compose down

# Clean up containers and images
clean:
	docker compose down -v
	docker rmi abfactor-server || true

# View server logs
logs:
	docker compose logs -f

# Access container shell
shell:
	docker compose exec abfactor-server bash

# Download server files (interactive)
download-server:
	mkdir -p server-data
	docker run -it --rm -v $$(pwd)/server-data:/home/wine/abfactor-server abfactor-server \
		/home/wine/steamcmd/steamcmd.sh +force_install_dir /home/wine/abfactor-server +login anonymous +app_update 2857710 +quit

# Run linting tools
lint:
	@echo "Running markdownlint..."
	@docker run --rm -v $$(pwd):/workspace davidanson/markdownlint-cli2 "**/*.md"
	@echo "Running yamllint..."
	@docker run --rm -v $$(pwd):/workspace cytopia/yamllint .
	@echo "Running hadolint (Dockerfile linter)..."
	@docker run --rm -i hadolint/hadolint < Dockerfile