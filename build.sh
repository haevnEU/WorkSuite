#!/usr/bin/env bash

clear
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if a service exists in docker-compose.dev.yml
check_service_exists() {
    local target_service="$1"
    if [ -z "$target_service" ]; then
        return 0 # Empty means all services, which is valid
    fi
    
    # Extract service names from docker-compose.dev.yml using docker compose config
    if docker compose -f docker-compose.dev.yml config --services 2>/dev/null | grep -qw "$target_service"; then
        return 0
    else
        return 1
    fi
}

# Optional service name as the first argument (if empty, all services are targeted)
SERVICE="${1:-}"

# Validate initial service argument if provided
if [ -n "$SERVICE" ]; then
    if ! check_service_exists "$SERVICE"; then
        echo -e "${RED}Error: Service '$SERVICE' does not exist in docker-compose.dev.yml!${NC}"
        SERVICE=""
    fi
fi

while true; do
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${CYAN} Docker Build & Up Tool (Dev Mode)${NC}"
    if [ -n "$SERVICE" ]; then
        echo -e " Active Service: ${GREEN}$SERVICE${NC}"
    else
        echo -e " Active Service: ${GREEN}All Services${NC}"
    fi
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${CYAN}1)${NC} docker compose build"
    echo -e "${CYAN}2)${NC} docker compose build --no-cache"
    echo -e "${CYAN}3)${NC} docker compose up"
    echo -e "${CYAN}4)${NC} Change service"
    echo -e "${CYAN}5)${NC} Cancel / Exit (or Ctrl+C)"
    read -p "Please select an option (1-5): " choice
    echo ""

    case "$choice" in
        1)
            echo -e "${YELLOW}Running build...${NC}"
            if [ -n "$SERVICE" ]; then
                docker compose -f docker-compose.dev.yml build "$SERVICE"
                echo -e "${YELLOW}Running up...${NC}"
                docker compose -f docker-compose.dev.yml up "$SERVICE"
            else
                docker compose -f docker-compose.dev.yml build
                echo -e "${YELLOW}Running up...${NC}"
                docker compose -f docker-compose.dev.yml up
            fi
            ;;
        2)
            echo -e "${YELLOW}Running build --no-cache...${NC}"
            if [ -n "$SERVICE" ]; then
                docker compose -f docker-compose.dev.yml build --no-cache "$SERVICE"
                echo -e "${YELLOW}Running up...${NC}"
                docker compose -f docker-compose.dev.yml up "$SERVICE"
            else
                docker compose -f docker-compose.dev.yml build --no-cache
                echo -e "${YELLOW}Running up...${NC}"
                docker compose -f docker-compose.dev.yml up
            fi
            ;;
        3)
            echo -e "${YELLOW}Running up...${NC}"
            if [ -n "$SERVICE" ]; then
                docker compose -f docker-compose.dev.yml up "$SERVICE"
            else
                docker compose -f docker-compose.dev.yml up
            fi
            ;;
        4)
            read -p "Enter the new service name (leave empty for all services): " new_service
            if [ -n "$new_service" ]; then
                if check_service_exists "$new_service"; then
                    SERVICE="$new_service"
                    echo -e "${GREEN}Service changed to: $SERVICE${NC}"
                else
                    echo -e "${RED}Error: Service '$new_service' does not exist in docker-compose.dev.yml! Keeping previous selection.${NC}"
                fi
            else
                SERVICE=""
                echo -e "${GREEN}Active service reset to: All Services${NC}"
            fi
            ;;
        5)
            echo -e "${RED}Exiting script.${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid input. Please choose between 1 and 5.${NC}"
            ;;
    esac

done