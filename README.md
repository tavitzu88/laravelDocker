# Laravel Docker Setup with NGINX Proxy

<img src="https://img.shields.io/badge/laravel-10%20%7C%2011%20%7C%2012-FF2D20.svg?logo=laravel&longCache=true" alt="Supported Laravel Versions" />
<img src="https://img.shields.io/badge/php-8.1%20%7C%208.2%20%7C%208.3%20%7C%208.4-777BB4.svg?logo=php&longCache=true" alt="Supported PHP Versions" />
<img src="https://img.shields.io/badge/maintained%3F-yes-brightgreen.svg" alt="Maintained - Yes" />

A complete Docker development environment for Laravel applications (10, 11, and 12) using [NGINX Proxy](https://github.com/adrianalin89/nginx-proxy) for multi-project setups. This setup provides a production-ready development environment with all the tools you need for modern Laravel development.

## Features

- ✨ **Laravel Support**: Full support for Laravel 10, 11, and 12
- 🐘 **Multiple PHP Versions**: Easy switching between PHP 8.1, 8.2, 8.3, and 8.4
- 🚀 **Auto-Starting Queue Workers**: Laravel queue workers start automatically with supervisor
- ⏰ **Task Scheduler**: Laravel scheduler runs every minute automatically
- 🔍 **Meilisearch Integration**: Fast, typo-tolerant search with Laravel Scout
- 📊 **Laravel Horizon**: Beautiful dashboard for monitoring Redis queues (optional)
- 🔭 **Laravel Telescope**: Debugging and profiling assistant (optional)
- 🎨 **Vite Support**: Hot module replacement for frontend development
- 🧪 **Code Quality Tools**: PHPStan, Laravel Pint, PHP_CodeSniffer included
- 🌐 **Multi-Project Support**: Run multiple Laravel projects on the same server
- 🔐 **SSL Certificates**: Automatic SSL certificate generation (Let's Encrypt or self-signed)
- 📧 **Global MailCatcher**: Test emails from all projects in one place
- 💾 **Global phpMyAdmin**: Access all project databases from http://db.test
- 🐳 **Docker Compose V2**: Modern Docker setup with external networks

## Container Services

The project consists of:
- **NGINX**: Web server with Laravel-optimized configuration
- **PHP-FPM**: PHP 8.1-8.4 with all Laravel extensions
- **MySQL**: MySQL 8.0 database
- **Redis (Valkey)**: Caching and session storage
- **Meilisearch**: Fast search engine for Laravel Scout

## Prerequisites

- [Docker & Docker Compose](https://docs.docker.com/engine/install/ubuntu/) - Container runtime
- [NGINX Proxy](https://github.com/adrianalin89/nginx-proxy) - Must be setup and running with global services:
  - MailCatcher (http://mail.test) - Email testing
  - phpMyAdmin (http://db.test) - Database management
  - Portainer (optional) - Container management

## Quick Start

```bash
# 1. Clone this repository
git clone <this-repo> {{project_name}} && cd {{project_name}}

# 2. Configure environment (!!! IMPORTANT !!! PROJECT NAME MUST BE LOWERCASE AND NO SPACES!!!)
cp .env.sample .env
nano .env  # Set PROJECT_NAME, USER_ID, GROUP_ID, PHP_VERSION

# 3. Setup Docker placeholders
bin/setup-docker

# 4. Create src directory
mkdir src

# 5. Start containers
bin/start

# 6. Create new Laravel project
bin/composer create-project laravel/laravel=^11.0 .

# 7. Access your application
# Add to /etc/hosts: 127.0.0.1 yourproject.test
# Visit: https://yourproject.test
```

## Project Structure
```
project-root/
├── bin/              # Project management scripts (50+ Laravel commands)
├── src/              # Laravel application source code
│   ├── app/          # Application code
│   ├── public/       # Public web root (NGINX points here)
│   ├── .env          # Laravel environment configuration
│   └── ...
├── images/
│   ├── nginx/        # NGINX configuration
│   └── php/          # PHP Dockerfiles (8.1, 8.2, 8.3, 8.4)
├── compose.yaml      # Docker services definition
└── .env              # Docker environment configuration
```

## Complete Setup Guide - From Zero to Running

### Part 1: Initial System Setup (First Time Only)

1. **Install Docker and Docker Compose**
   ```bash
   # Follow official Docker installation guide
   # https://docs.docker.com/engine/install/ubuntu/
   ```

2. **Setup NGINX Proxy** (if not already running)
   ```bash
   git clone https://github.com/adrianalin89/nginx-proxy
   cd nginx-proxy
   # Follow setup instructions in that repository
   bin/start
   ```

3. **Verify Global Services**
   - MailCatcher: http://mail.test
   - phpMyAdmin: http://db.test
   - Portainer: (if configured)

### Part 2: Project Configuration

1. **Clone or Download This Repository**
   ```bash
   git clone <this-repo> {{project_name}}
   cd {{project_name}}
   ```

2. **Copy and Configure `.env`** (!!! IMPORTANT !!! PROJECT NAME MUST BE LOWERCASE AND NO SPACES!!!)
   ```bash
   cp .env.sample .env
   nano .env
   ```

   **Important Settings:**
   - `PROJECT_NAME={{project_name}}` (your project name, lowercase, no spaces)
   - `USER_ID=1000` (run `id -u` to get your user ID)
   - `GROUP_ID=1000` (run `id -g` to get your group ID)
   - `DOMAIN_HOSTS={{project_name}}.test` (your local domain)
   - `DOMAIN_EMAIL=admin@{{project_name}}.test`
   - `PHP_VERSION=8.3` (choose: 8.1, 8.2, 8.3, or 8.4)
   - `MYSQL_DATABASE={{project_name}}`
   - `MYSQL_USER=laravel`
   - `MYSQL_PASSWORD=laravel`
   - `MYSQL_ROOT_PASSWORD=root`
   - `MEILISEARCH_KEY=masterKey` (change for production)

3. **Run Setup Script**
   ```bash
   bin/setup-docker
   ```
   This replaces `{{project_name}}` placeholders throughout the project.

4. **Create Source Directory**
   ```bash
   mkdir src
   ```

### Part 3A: Setup New Laravel Project

1. **Start Docker Containers**
   ```bash
   bin/start
   ```
   First start will take a while to build images. Wait for all containers to be running.

2. **Create New Laravel Project**
   ```bash
   # Laravel 10
   bin/composer create-project laravel/laravel=^10.0 .

   # Laravel 11
   bin/composer create-project laravel/laravel=^11.0 .

   # Laravel 12
   bin/composer create-project laravel/laravel=^12.0 .
   ```

3. **Configure Laravel `.env` File** (in `src/.env`)
   ```bash
   cd src
   replace .env with .envLaravelSample
   nano .env
   replace mylaravel with your project name
   ```

   **Database Configuration:**
   ```env
   DB_CONNECTION=mysql
   DB_HOST={{project_name}}-db
   DB_PORT=3306
   DB_DATABASE={{project_name}}
   DB_USERNAME=laravel
   DB_PASSWORD=laravel
   ```

   **Redis Configuration:**
   ```env
   REDIS_HOST={{project_name}}-redis
   REDIS_PASSWORD=null
   REDIS_PORT=6379
   ```

   **Mail Configuration (MailCatcher):**
   ```env
   MAIL_MAILER=smtp
   MAIL_HOST=mailcatcher
   MAIL_PORT=1025
   MAIL_USERNAME=null
   MAIL_PASSWORD=null
   MAIL_ENCRYPTION=null
   MAIL_FROM_ADDRESS="hello@{{project_name}}.test"
   MAIL_FROM_NAME="${APP_NAME}"
   ```

   **Meilisearch Configuration (Laravel Scout):**
   ```env
   SCOUT_DRIVER=meilisearch
   MEILISEARCH_HOST=http://{{project_name}}-meilisearch:7700
   MEILISEARCH_KEY=masterKey
   ```

4. **Generate Application Key**
   ```bash
   bin/artisan key:generate
   ```

5. **Run Database Migrations**
   ```bash
   bin/migrate
   ```

6. **Optional: Seed Database**
   ```bash
   bin/seed
   ```

7. **Add Domain to Hosts File**
   ```bash
   # Linux/Mac
   sudo nano /etc/hosts
   # Add: 127.0.0.1 {{project_name}}.test

   # Windows
   # Edit: C:\Windows\System32\drivers\etc\hosts
   # Add: 127.0.0.1 {{project_name}}.test
   ```

8. **Restart NGINX Proxy** (to generate SSL certificates)
   ```bash
   cd /path/to/nginx-proxy
   bin/restart
   ```

9. **Access Your Application**
    - Open: https://{{project_name}}.test
    - MailCatcher: http://mail.test
    - phpMyAdmin: http://db.test (server: {{project_name}}-db)

### Part 3B: Setup Existing Laravel Project

1. **Start Docker Containers**
   ```bash
   bin/start
   ```

2. **Clone Your Project**
   ```bash
   cd src
   git clone <YOUR_REPOSITORY_URL> .
   ```

3. **Install Dependencies**
   ```bash
   bin/composer install
   bin/npm install
   ```

4. **Configure Laravel `.env`**
   ```bash
   cd src   
   replace .env with .envLaravelSample
   nano .env
   replace mylaravel with your project name
   # Configure database, Redis, mail (same as Part 3A step 3)
   ```

5. **Generate Application Key**
   ```bash
   bin/artisan key:generate
   ```

6. **Database Setup**

   **Option A: Import Existing Database**
   ```bash
   # Place SQL file in project root (not in src/)
   bin/clinotty mysql -h {{project_name}}-db -u root -p'root' {{project_name}} < backup.sql
   ```

   **Option B: Run Migrations**
   ```bash
   bin/migrate
   bin/seed  # optional
   ```

7. **Build Assets**
   ```bash
   bin/vite-build  # Production build
   # OR
   bin/vite        # Development server with HMR
   ```

8. **Add Domain to Hosts File** (see Part 3A step 7)

9. **Restart NGINX Proxy** (see Part 3A step 8)

10. **Access Your Application** (see Part 3A step 9)

### Part 4: Post-Setup - Laravel Features

#### Queue Workers (Already Running!)
Queue workers start automatically via supervisor. No additional setup needed!
```bash
# Check worker status
bin/cli supervisorctl status

# View worker logs
bin/cli supervisorctl tail -f laravel-worker
```

#### Task Scheduler (Already Running!)
The Laravel scheduler runs every minute automatically via cron.
```bash
# Verify scheduler is working
bin/cli crontab -l
```

#### Install Laravel Horizon (Optional)
```bash
bin/composer require laravel/horizon
bin/artisan horizon:install
bin/migrate

# Update supervisor to use Horizon instead of queue:work
# Edit images/php/{version}/conf/supervisord.conf
# Comment out [program:laravel-worker]
# Uncomment [program:horizon]
# Restart containers
bin/restart

# Access Horizon dashboard
# Visit: https://{{project_name}}.test/horizon
```

#### Install Laravel Telescope (Optional)
```bash
bin/composer require laravel/telescope --dev
bin/artisan telescope:install
bin/migrate

# Access Telescope dashboard
# Visit: https://{{project_name}}.test/telescope
```

#### Setup Laravel Scout with Meilisearch (Optional)
```bash
bin/composer require laravel/scout
bin/composer require meilisearch/meilisearch-php http-interop/http-factory-guzzle
bin/artisan vendor:publish --provider="Laravel\Scout\ScoutServiceProvider"

# Make a model searchable
# Add 'use Searchable;' trait to your model
# Import existing data
bin/scout-import "App\Models\Post"
```

## Laravel Version Support Matrix

| Laravel | PHP 8.1 | PHP 8.2 | PHP 8.3 | PHP 8.4 |
|---------|---------|---------|---------|---------|
| 10.x    | ✅      | ✅      | ✅      | ❌      |
| 11.x    | ❌      | ✅      | ✅      | ✅      |
| 12.x    | ❌      | ❌      | ✅      | ✅      |

To change PHP version:
1. Update `PHP_VERSION` in `.env`
2. Rebuild containers: `bin/restart`

## CLI Commands Reference

### Essential Commands
- **`bin/start`**: Start all containers (builds images on first run)
- **`bin/stop`**: Stop all project containers
- **`bin/restart`**: Stop and then start all containers
- **`bin/status`**: Check the status of all containers
- **`bin/setup-docker`**: Replace {{project_name}} placeholders with actual project name

### Container Access
- **`bin/bash`**: Drop into bash prompt of PHP container
- **`bin/cli <command>`**: Run any CLI command in PHP container. Ex: `bin/cli ls`
- **`bin/clinotty <command>`**: Run CLI command without TTY. Ex: `bin/clinotty chmod +x script.sh`
- **`bin/root <command>`**: Run command as root. Ex: `bin/root apt-get install nano`
- **`bin/rootnotty <command>`**: Run root command without TTY

### Laravel Commands
- **`bin/artisan <command>`**: Run Laravel Artisan commands. Ex: `bin/artisan make:model Post`
- **`bin/tinker`**: Open Laravel Tinker REPL
- **`bin/migrate`**: Run database migrations
- **`bin/seed`**: Run database seeders
- **`bin/test-laravel`**: Run PHPUnit/Pest tests

### Database Commands
- **`bin/mysql`**: Access MySQL CLI. Ex: `bin/mysql -e "SHOW DATABASES;"`
- **`bin/mysqldump`**: Backup database. Ex: `bin/mysqldump > backup.sql`

### Queue & Scheduler
- **`bin/queue-work`**: Run queue worker manually
- **`bin/horizon`**: Run Laravel Horizon (if installed)
- **Queue workers auto-start** via supervisor (no manual intervention needed!)
- **Laravel scheduler runs automatically** every minute via cron

### Frontend Development
- **`bin/vite`**: Start Vite dev server with HMR
- **`bin/vite-build`**: Build assets for production
- **`bin/npm <command>`**: Run npm commands. Ex: `bin/npm install`
- **`bin/node <command>`**: Run node commands

### Code Quality
- **`bin/pint`**: Format code with Laravel Pint
- **`bin/phpstan`**: Run PHPStan static analysis

### Caching Commands
- **`bin/cache-clear`**: Clear all Laravel caches
- **`bin/optimize`**: Optimize Laravel (cache config, routes, views)
- **`bin/optimize-clear`**: Clear all optimization caches
- **`bin/config-cache`**: Cache configuration
- **`bin/route-cache`**: Cache routes
- **`bin/view-cache`**: Cache views

### Laravel Scout / Meilisearch
- **`bin/scout-import <model>`**: Import model to Meilisearch. Ex: `bin/scout-import "App\Models\Post"`
- **`bin/scout-flush <model>`**: Flush Meilisearch index

### Development Tools
- **`bin/composer <command>`**: Run Composer. Ex: `bin/composer install`
- **`bin/xdebug <action>`**: Enable/disable Xdebug. Ex: `bin/xdebug enable`

### Docker Management
- **`bin/docker-compose <command>`**: Run docker compose commands
- **`bin/docker-stats`**: Display container resource usage
- **`bin/copyfromcontainer <path>`**: Copy files from container to host
- **`bin/copytocontainer <path>`**: Copy files from host to container

### Redis Commands
- **`bin/redis <command>`**: Access Redis CLI. Ex: `bin/redis redis-cli monitor`

## Global Tools Access

### phpMyAdmin
- **Access**: http://db.test
- **Server Name**: `{PROJECT_NAME}-db` (e.g., `{{project_name}}-db`)
- **Username**: Use `MYSQL_USER` from your `.env`
- **Password**: Use `MYSQL_PASSWORD` from your `.env`
- **Features**: Manage all project databases from one place

### MailCatcher
- **Web UI**: http://mail.test
- **SMTP Host**: `mailcatcher` (from containers)
- **SMTP Port**: `1025`
- **Features**: View emails from all Laravel projects in one interface

**Test Email Example:**
```bash
bin/tinker
# In Tinker:
Mail::raw('Test email', fn($m) => $m->to('test@example.com')->subject('Test'));
# Check MailCatcher UI to see the email
```

### Portainer (if configured)
- Container management and monitoring
- View logs, stats, and console access

## Multiple Domain Configuration

You can run multiple domains for one project:

1. Update `.env` file:
   ```env
   DOMAIN_HOSTS={{project_name}}.test,api.{{project_name}}.test,admin.{{project_name}}.test
   ```

2. Run `bin/setup-docker` to update placeholders

3. Add all domains to `/etc/hosts`:
   ```
   127.0.0.1 {{project_name}}.test api.{{project_name}}.test admin.{{project_name}}.test
   ```

4. Restart NGINX Proxy to generate SSL certificates for all domains

## Password Protection (HTPASSWD)

To add HTTP basic authentication:

1. **Create `.htpasswd` file:**
   ```bash
   sh -c "echo -n 'admin:' >> images/nginx/.htpasswd"
   sh -c "openssl passwd -apr1 >> images/nginx/.htpasswd"
   ```

2. **Enable in NGINX config** (`images/nginx/default.conf`):
   ```nginx
   location / {
       try_files $uri $uri/ /index.php?$query_string;
       auth_basic "Restricted Area";
       auth_basic_user_file /etc/nginx/.htpasswd;
   }
   ```

3. **Mount `.htpasswd` in compose.yaml:**
   ```yaml
   {{project_name}}-nginx:
     volumes:
       - ./images/nginx/.htpasswd:/etc/nginx/.htpasswd
   ```

4. **Restart containers:**
   ```bash
   bin/restart
   ```

## Troubleshooting

### Container Won't Start
- Check Docker is running: `docker ps`
- Check logs: `bin/docker-compose logs`
- Verify no port conflicts
- Ensure `.env` is configured correctly

### Permission Denied Errors
Verify `USER_ID` and `GROUP_ID` in `.env` match your system (`id -u` and `id -g`).
Laravel will handle file permissions automatically when containers run with correct user/group IDs.

### Database Connection Failed
- Verify MySQL container is running: `bin/status`
- Check credentials in `src/.env` match Docker `.env`
- Confirm `DB_HOST` is `{PROJECT_NAME}-db`
- Test connection: `bin/mysql -e "SHOW DATABASES;"`

### Can't Access phpMyAdmin
- Verify NGINX Proxy is running
- Check http://db.test
- Server name must be: `{PROJECT_NAME}-db`
- Use MySQL credentials from Docker `.env`

### MailCatcher Not Receiving Emails
- Verify `mail-catcher-network` exists: `docker network ls`
- Check Laravel `.env`: `MAIL_HOST=mailcatcher`, `MAIL_PORT=1025`
- Ensure PHP container connected to `mail-catcher-network`

### Queue Jobs Not Processing
```bash
# Check supervisor status
bin/cli supervisorctl status

# View worker logs
bin/cli supervisorctl tail -f laravel-worker

# Restart workers
bin/restart

# Check Redis
bin/redis redis-cli ping
```

### Laravel Scheduler Not Running
```bash
# Check cron is running
bin/cli ps aux | grep cron

# Verify crontab
bin/cli crontab -l
```

### Supervisor Configuration
Supervisor runs as root user but child processes (PHP-FPM, cron, laravel-worker) run as www-data. This is the correct configuration for proper permissions handling.

**Socket Location**: `/var/run/supervisor.sock`

**No Authentication Required**: supervisorctl commands work without authentication flags.

```bash
# Correct supervisorctl usage (no -c flag needed)
bin/cli supervisorctl status
bin/cli supervisorctl tail -f laravel-worker
bin/cli supervisorctl restart laravel-worker
```

**If supervisor fails to start**, check:
- Container logs: `bin/docker-compose logs {{project_name}}-php`
- Supervisor must run as root (user=root in supervisord.conf)
- Child processes run as www-data (specified in each program config)

### SSL Certificates Not Generated
- Restart NGINX Proxy after starting project containers
- Verify `DOMAIN_HOSTS` in `.env`
- For local development, ensure `SELF_SIGNED_HOST` is set in NGINX Proxy
- Check NGINX Proxy logs

### Vite Dev Server Issues
- Ensure Vite is running: `bin/vite`
- Check `vite.config.js` server settings
- Verify no port conflicts on 5173
- For HMR issues, may need to configure host in vite.config.js

### Xdebug Not Working
```bash
# Enable Xdebug
bin/xdebug enable

# Restart containers
bin/restart

# Verify configuration
bin/cli cat /usr/local/etc/php/conf.d/php.ini | grep xdebug
```
- Check IDE configuration (port 9003)
- Verify path mappings: `/var/www/src` → `${workspaceFolder}/src`
- Use browser extension (Xdebug Helper)

### Viewing Logs
```bash
# Laravel logs (direct file access)
bin/cli tail -f storage/logs/laravel.log

# All container logs
bin/docker-compose logs

# Specific service
bin/docker-compose logs {{project_name}}-nginx
bin/docker-compose logs {{project_name}}-php

# Supervisor logs
bin/cli supervisorctl tail -f laravel-worker
```

## Redis Configuration

Redis is automatically configured and ready to use for:
- **Cache**: Speeds up application performance
- **Sessions**: User session storage
- **Queues**: Job queue backend

**Configuration in Laravel `.env`:**
```env
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

REDIS_HOST={{project_name}}-redis
REDIS_PASSWORD=null
REDIS_PORT=6379
```

**Monitor Redis:**
```bash
bin/redis redis-cli monitor
```

**Useful Redis Commands:**
```bash
# Check Redis connection
bin/redis redis-cli ping

# View all keys
bin/redis redis-cli KEYS '*'

# Flush all data (careful!)
bin/redis redis-cli FLUSHALL

# Get Redis info
bin/redis redis-cli INFO
```

## Xdebug Setup

### VS Code Configuration

1. **Install PHP Debug Extension**
   - Install from [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)

2. **Enable Xdebug**
   ```bash
   bin/xdebug enable
   bin/restart
   ```

3. **Create `.vscode/launch.json` in Project Root**
   ```json
   {
       "version": "0.2.0",
       "configurations": [
           {
               "name": "Listen for Xdebug",
               "type": "php",
               "request": "launch",
               "port": 9003,
               "pathMappings": {
                   "/var/www/src": "${workspaceFolder}/src"
               }
           }
       ]
   }
   ```

4. **Start Debugging**
   - Set breakpoints in your Laravel code
   - Press F5 or click "Start Debugging"
   - Make a request to your application
   - Debugger will pause at breakpoints

### VS Code in WSL2

If running in WSL2, follow the above steps with these additions:

1. **Open VS Code in WSL Window**
   - Use `code .` from WSL terminal

2. **Allow WSL Through Firewall** (Windows PowerShell as Admin)
   ```powershell
   New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (WSL)" -Action Allow
   ```

3. **Path Mappings in launch.json**
   ```json
   "pathMappings": {
       "/var/www/src": "${workspaceFolder}/src"
   }
   ```

### PhpStorm Configuration

1. **Install Chrome Xdebug Helper**
   - Install [Chrome Xdebug Helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc)
   - Set IDE Key to "PHPSTORM"

2. **Enable Xdebug**
   ```bash
   bin/xdebug enable
   bin/restart
   ```

3. **Configure PHP Interpreter**
   - Go to `PhpStorm > Preferences > PHP`
   - Click `...` next to CLI Interpreter
   - Add new interpreter: `From Docker, Vagrant, VM...`
   - Select `Docker Compose`
   - Configuration files: `compose.yaml`
   - Service: Select PHP service
   - Name it `phpfpm` and click OK

4. **Configure Debug Settings**
   - Go to `PhpStorm > Preferences > PHP > Debug`
   - Set Debug Port to `9003`

5. **Configure Server**
   - Go to `PhpStorm > Preferences > PHP > Servers`
   - Click `+` to add new server
   - Name: `{{project_name}}.test` (your domain)
   - Host: `{{project_name}}.test`
   - Port: `80`
   - Check "Use path mappings"
   - Map `src` → `/var/www/src`

6. **Create Debug Configuration**
   - Go to `Run > Edit Configurations`
   - Click `+` → `PHP Remote Debug`
   - Name: `{{project_name}}.test`
   - Check "Filter debug connection by IDE key"
   - Server: Select the server you created
   - IDE key: `PHPSTORM`

7. **Start Debugging**
   - Set breakpoint in Laravel code (e.g., `routes/web.php`)
   - Click "Start Listening for PHP Debug Connections" (phone icon)
   - Enable Xdebug in Chrome (click extension, select "Debug")
   - Visit your Laravel site
   - PhpStorm will pause at breakpoints

## Performance Tips

### Optimize Docker Performance

1. **Allocate More Resources to Docker**
   - Docker Desktop: Settings → Resources
   - Increase CPUs and Memory

2. **Use Docker Volumes for node_modules**
   - Prevents slow file system operations

3. **Disable Xdebug When Not Debugging**
   ```bash
   bin/xdebug disable
   bin/restart
   ```

### Laravel Performance

1. **Cache Configuration**
   ```bash
   bin/optimize  # Cache config, routes, views
   ```

2. **Use Queues for Slow Tasks**
   - Move slow operations to background jobs
   - Queue workers handle them asynchronously

3. **Enable OPcache** (Already enabled in PHP images)

4. **Use Laravel Horizon** for better queue management

## TODO / Planned Features

### Deployment Script
Create a `bin/deploy` script for Laravel deployments that includes:
- Put application in maintenance mode (`bin/artisan down`)
- Pull latest code from git
- Install/update Composer dependencies (`--no-dev --optimize-autoloader`)
- Run database migrations (`bin/migrate --force`)
- Clear and optimize caches (`bin/optimize-clear` && `bin/optimize`)
- Restart queue workers (`bin/cli supervisorctl restart laravel-worker`)
- Build frontend assets (`bin/vite-build`)
- Bring application back online (`bin/artisan up`)

This will provide zero-downtime deployment workflow similar to the Magento setup that was removed during cleanup.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an issue.

## License

This project is a Docker-based development environment specifically designed for modern Laravel applications.

## Support

For issues related to:
- **This Laravel setup**: Open an issue in this repository
- **NGINX Proxy**: Check the [nginx-proxy documentation](https://github.com/adrianalin89/nginx-proxy)
- **Laravel**: Visit [Laravel Documentation](https://laravel.com/docs)
- **Docker**: Check [Docker Documentation](https://docs.docker.com)
