[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License: CC BY-NC-SA 4.0][license-shield]][license-url]

<br />
<p align="center">
  <h3 align="center">COVID-19 Scraper</h3>

  <p align="center">
    Collection of jobs which scrape, parse and export coronavirus data automatically.
    <br />
    <a href="https://coronavirus-bulgaria.org/"><strong>Live Demo</strong></a>
    <br />
    <br />
    <a href="https://github.com/COVID-19-Bulgaria/covid-scraper/issues">Report Bug</a>
    ·
    <a href="https://github.com/COVID-19-Bulgaria/covid-scraper/issues">Request Feature</a>
  </p>
</p>

## Table of Contents

* [About the Project](#about-the-project)
  * [Built With](#built-with)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)

## About The Project

This project is a collection of jobs that scrape websites of official coronavirus data sources (e.g. Ministry of Health), parse the data and export it in a common format. Ultimately the exported data is automatically commited to the [covid-database repository](https://github.com/COVID-19-Bulgaria/covid-scraper). Currently there are jobs for Bulgaria data only, but soon it will support other countries as well.

### Built With
* [Sidekiq](https://sidekiq.org/)
* [sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron)
* etc.

## Getting Started

To get a local copy up and running follow these simple example steps.

### Prerequisites

* npm
```sh
gem install bundler
```

### Installation

1. Clone the repo
```sh
git clone https://github.com/COVID-19-Bulgaria/covid-scraper.git
```
2. Install dependencies
```sh
bundle install
```

## Usage

Run sidekiq:
```sh
bundle exec sidekiq -C ./config/sidekiq.yml -r ./crontab.rb
```

Run sidekiq-web:
```sh
bundle exec rackup config.ru
```

Or run both:
```sh
bundle exec foreman start
```

If you use foreman you can specify all environment variables within a `.env` file in the mail directory. Otherwise you will need to export them in the current terminal either by hand or with a script.

Then access http://localhost:9292, start developing and monitor the jobs execution!

## Roadmap

See the [open issues](https://github.com/COVID-19-Bulgaria/covid-scraper/issues) for a list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

[![Creative Commons License](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)
Project is distributed under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).

## Contact

Veselin Stoyanov:
[![LinkedIn][linkedin-shield]][linkedin-url]

[contributors-shield]: https://img.shields.io/github/contributors/COVID-19-Bulgaria/covid-scraper.svg?style=flat-square
[contributors-url]: https://github.com/COVID-19-Bulgaria/covid-scraper/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/COVID-19-Bulgaria/covid-scraper.svg?style=flat-square
[forks-url]: https://github.com/COVID-19-Bulgaria/covid-scraper/network/members
[stars-shield]: https://img.shields.io/github/stars/COVID-19-Bulgaria/covid-scraper.svg?style=flat-square
[stars-url]: https://github.com/COVID-19-Bulgaria/covid-scraper/stargazers
[issues-shield]: https://img.shields.io/github/issues/COVID-19-Bulgaria/covid-scraper.svg?style=flat-square
[issues-url]: https://github.com/COVID-19-Bulgaria/covid-scraper/issues
[license-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg?style=flat-square
[license-url]: https://creativecommons.org/licenses/by-nc-sa/4.0/
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?logo=linkedin&color=blue
[linkedin-url]: https://www.linkedin.com/in/stoyanovv/
