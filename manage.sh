#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Nginx + Express Docker Setup Manager     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Create nginx logs directory if it doesn't exist
if [ ! -d "nginx/logs" ]; then
    print_info "Creating nginx/logs directory..."
    mkdir -p nginx/logs
    print_success "Directory created"
fi

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

print_success "Docker and Docker Compose are installed"
echo ""

# Menu
echo "Select an option:"
echo "1) Start all services"
echo "2) Stop all services"
echo "3) Restart all services"
echo "4) Rebuild and start"
echo "5) View logs (all)"
echo "6) View Nginx logs only"
echo "7) View Server 1 logs only"
echo "8) View Server 2 logs only"
echo "9) Check service status"
echo "10) Test endpoints"
echo "11) Reload Nginx config"
echo "0) Exit"
echo ""
read -p "Enter your choice: " choice

case $choice in
    1)
        print_info "Starting all services..."
        docker-compose up -d
        print_success "Services started!"
        echo ""
        print_info "Access points:"
        echo "  - Nginx: http://localhost/"
        echo "  - API Hello: http://localhost/api/hello"
        echo "  - API Users: http://localhost/api/users"
        echo "  - API Products: http://localhost/api/products"
        ;;
    2)
        print_info "Stopping all services..."
        docker-compose down
        print_success "Services stopped!"
        ;;
    3)
        print_info "Restarting all services..."
        docker-compose restart
        print_success "Services restarted!"
        ;;
    4)
        print_info "Rebuilding and starting services..."
        docker-compose up -d --build
        print_success "Services rebuilt and started!"
        ;;
    5)
        print_info "Showing all logs (Press Ctrl+C to exit)..."
        docker-compose logs -f
        ;;
    6)
        print_info "Showing Nginx logs (Press Ctrl+C to exit)..."
        docker-compose logs -f nginx
        ;;
    7)
        print_info "Showing Server 1 logs (Press Ctrl+C to exit)..."
        docker-compose logs -f server1
        ;;
    8)
        print_info "Showing Server 2 logs (Press Ctrl+C to exit)..."
        docker-compose logs -f server2
        ;;
    9)
        print_info "Service Status:"
        docker-compose ps
        ;;
    10)
        print_info "Testing endpoints..."
        echo ""
        
        echo "Testing Nginx root:"
        curl -s http://localhost/ && print_success "Nginx is running!" || print_error "Nginx failed"
        echo ""
        
        echo "Testing /api/hello:"
        curl -s http://localhost/api/hello && print_success "Server 1 responding!" || print_error "Server 1 failed"
        echo ""
        
        echo "Testing /api/users:"
        curl -s http://localhost/api/users && print_success "Server 2 (users) responding!" || print_error "Server 2 (users) failed"
        echo ""
        
        echo "Testing /api/products:"
        curl -s http://localhost/api/products && print_success "Server 2 (products) responding!" || print_error "Server 2 (products) failed"
        echo ""
        ;;
    11)
        print_info "Reloading Nginx configuration..."
        docker-compose exec nginx nginx -s reload && print_success "Nginx config reloaded!" || print_error "Failed to reload Nginx"
        ;;
    0)
        print_info "Exiting..."
        exit 0
        ;;
    *)
        print_error "Invalid choice!"
        exit 1
        ;;
esac