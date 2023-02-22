# Decidim Transparent Trash module

Module implements a new space in Decidim initiatives index where initiatives marked as **Invalidated** and **Illegal**
are accessible.
These previous states are only available with this module.

> 🚧 Overrides
>
> This feature requires to extend components like commands, controllers, permission and views of the decidim-initiatives
> engine. It may occur unexpected behaviours, an exhaustive list of overrides is available.

## Usage

TransparentTrash will be available as a Component for a Participatory
Space.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-transparent_trash", git: "https://github.com/opensourcepolitics/decidim-module-transparent_trash.git"
```

And then execute:

```bash
bundle
```

### Informations

| _                            | Presence |
|:-----------------------------|:--------:|
| Database migrations          |    ❌     |
| Webpacker assets             |    ❌     |
| Env variables                |    ❌     |
| Data structure changes       |    ❌     |
| New states for initiatives   |    ✅     |
| Changes on initiatives index |     ❌     |

## Contributing

Contributions are welcome !

We expect the contributions to follow
the [Decidim's contribution guide](https://github.com/decidim/decidim/blob/develop/CONTRIBUTING.adoc).

## Security

Security is very important to us. If you have any issue regarding security, please disclose the information responsibly
by sending an email to __security [at] opensourcepolitics [dot] eu__ and not by creating a Github issue.

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
