# Web Scraper & Product Management App

## Overview
This is a full-stack web application that scrapes product details from an e-commerce webpage and displays them in a user-friendly interface. The backend is built with **Ruby on Rails**, and the frontend is developed using **React**.
![image](https://github.com/user-attachments/assets/b3d74c0f-6f76-4127-94b1-15bdac53f007)

## Features
- **Web Scraping**: Extracts product details (title, description, price, etc.) from e-commerce URLs.
- **Database Management**: Stores and categorizes scraped product data.
- **Search & Filtering**: Enables users to search and filter products with an asynchronous search.
- **Auto-Update**: Refetches outdated product data (older than a week) asynchronously.
- **Responsive UI**: Users can submit URLs for scraping and view products by category.
- **Testing**: Includes test coverage for critical functionality.

---

## Tech Stack
- **Backend**: Ruby on Rails
- **Frontend**: React, JavaScript
- **Database**: PostgreSQL
---

## Setup Instructions

### Prerequisites
Make sure you have the following installed:
- Ruby (v3.x recommended)
- Rails (v7.x recommended)
- PostgreSQL
- Node.js & npm
- Yarn (optional but recommended)

### Backend (Rails API)
1. Clone the repository:
   ```bash
   git clone https://github.com/Athikajishida/Web_scraper.git
   cd Web_scraper/scraper_api
   ```
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Set up the database:
   ```bash
   rails db:create db:migrate
   ```
4. Start the Rails server:
   ```bash
   rails s
   ```

### Frontend (React)
1. Navigate to the frontend directory:
   ```bash
   cd ../scraper-frontend

   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the React development server:
   ```bash
   npm run dev
   ```

The frontend should now be accessible at `http://localhost:5173`, and the backend API should run at `http://localhost:3000`.

---

## Testing
Run tests to verify core functionalities:

### Backend Tests (Rails)
```bash
rspec
```

### Frontend Tests (React)
```bash
npm test
```
---

## Contribution Guidelines
If you'd like to contribute:
1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature-name
   ```
3. Make your changes and commit:
   ```bash
   git commit -m "Describe your changes"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Create a Pull Request (PR) on GitHub.

---

## Next Steps & Future Improvements
- Improve error handling for failed scrapes.
- Implement user authentication.
- Deploy the app to a cloud platform.

---


