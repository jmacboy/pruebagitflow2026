#!/bin/bash
hostname=$(curl http://169.254.169.254/metadata/v1/hostname)
mkdir -p /home/deploy
cd /home/deploy
echo "services:
  postgres:
    image: postgres:16
    container_name: postgres-diplomado-2
    environment:
      POSTGRES_PASSWORD: postgresspassword
      POSTGRES_USER: postgres
      POSTGRES_DB: mydb
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
  api:
    image: jmdiplomado/pruebagitflow2026:$hostname
    container_name: inventory-api
    ports:
      - "80:8080"
    depends_on:
      - postgres
    environment:
      ASPNETCORE_ENVIRONMENT: Development
      ConnectionStrings__InventoryDatabase: Host=postgres;Port=5432;Database=StoreInventory;Username=postgres;Password=postgresspassword;Include Error Detail=true

volumes:
  postgres_data:
" > compose.yml
docker compose up -d