# Drupal Devcontainer

Full featured, easy to use IDE for Drupal based on VSCode and Docker Desktop.

##### :warning: Do not clone this repository. Fork it first!
>
> **Note:** This repository is designed to be used as the basis of a Drupal website project. Therefore you should fork the repository, set this repository as "upstream" remote, and commit changes to your own repository. A generator is in the works to make this process easier. If your intention is to test out this system without creating a new project, then feel free to clone directly. Detailed usage instructions follow. 

### Workflow-centric development

Project goals include:

- Complete Drupal IDE
- Primary support for familiar tools: Composer, Drush, Drupal console
- One touch up development virtual machine
- Important working directories live in project root
- Lightweight: Drupal is not installed into repository
- Extensible... other kinds of Drupal setups are supported with base features, modules, or themes
- Deployment to shared hosts or cloud (planned)

These goals are achieved using [Docker Desktop](https://www.docker.com/products/docker-desktop) and [Microsoft's VSCode](https://code.visualstudio.com/). The development virtual machine Docker code is based on [Ricardo Amaro's drupal8-docker-app](https://github.com/ricardoamaro/drupal8-docker-app) but the stack is subject to change.

[Directly supported workflows](#workflows) are documented below.

See [Directory layout](#directory-layout) for details on the repository files.

### Workflows:
 - [Install IDE: VSCode and Docker Desktop](#system-setup)
 - [Start a project](#project-setup)
 - [Create a new theme](#create-a-new-theme)
 - [Create a new module](#create-a-new-module)
 - [Install a third party theme](#install-a-third-party-theme)
 - [Install a third party module](#install-a-third-party-module)
 - [Deploy to remote server](#deploy-to-remote-server) (under construction)
 - [Update modules or Drupal core](#update-modules-or-drupal-core)
 - [Update Drupal Devcontainer](#update-drupal-devcontainer)
 - [Create an extended Drupal Devcontainer for reuse](#create-an-extended-drupal-devcontainer-for-reuse)

Don't see a workflow that is important to you? Pull requests and discussion is welcome!

### Directory layout:

`./modules` Custom modules for the site. All modules in this directory will be automatically enabled on container build.

`./themes` Custom themes for the site. All themes in this directory will be automatically enabled on container build.

`./features` Configuration via Features that should be applied to all environments (dev, qa, staging, production etc). All themes in this directory will be automatically enabled on container build. When generating features from development environment, specify output directory `/var/www/html/web/modules/custom_features`.

`./.env` Environment variables file.

`./.composer.json` Project composer file.

`./.base` This directory can contain modules, themes, features that are not the primary target of the current website. It is meant to create reusable distributions based on forks of Drupal Devcontainer. TODO: examples e.g. commerce focused setup.

`./.devcontainer/` Contains VSCode development files. Only needs changes if you intend to modify the development stack (Ubuntu, Apache, PHP, MariaDB, Memcached).

### System setup:

- Install Docker Desktop
- Install VSCode
- Install VSCode Remote Containers extension

### Project setup:

:ballot_box_with_check: Fork this project named for new website

- TODO: instructions for upstream remote
- Clone your new fork
- Edit `.env` file `SITE_NAME` and other optional details
- Commit and push your `.env` changes.
- In VSCode, "Reopen folder as container"

### Create a new theme

#### Use Drush to create new theme

#### Add third party theme as dependency

### Create a new module

#### Use Drush to create new module

#### Add third party modules as dependencies

### Install a third party theme

:warning: If the theme you are installing is a requirement, a base theme for your custom theme you are building, consider [adding it as a theme dependency](#add-third-party-theme-as-dependency) instead of adding it to the top level `composer.json` as described here.

```bash
    /workspace# cd /var/www/html
    /var/www/html# composer require drupal/acmetheme
    /var/www/html# drush en acmetheme
    /var/www/html# drush cr
```

 :arrow_up: Replace `acmetheme` above with the project name of the theme as given on drupal.org. 

:ballot_box_with_check: Add and commit the changes to `composer.json` into Git with a message about adding a new third party theme.

### Install a third party module

*Note:* if the module you are installing is a requirement for a custom module you are building, consider [adding it as a module dependency](#add-third-party-modules-as-dependencies) instead of adding it to the top level `composer.json` as described here.

```bash
    /workspace# cd /var/www/html
    /var/www/html# composer require drupal/acmewidget
    /var/www/html# drush en acmewidget
    /var/www/html# drush cr
```

 :arrow_up: Replace `acmewidget` with the project name of the module as given on drupal.org. 

Add and commit the changes to `composer.json` into Git with a message about adding a new third party module and the purpose of it.


### Deploy to remote server

### Update modules or Drupal core

### Update Drupal Devcontainer

### Create an extended Drupal Devcontainer for reuse

