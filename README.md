# InverseAuth

The Inverse auth libraries for the Elixir Projects.

## Modules

### InverseAuth.Auth

A template for auth models that are project specific.

### InverseAuth.JWT

A module to decode JWT tokens.

### InverseAuth.Plug

A plug to be used to decode JWT tokens and assign them to `conn.assigns.user`.

## Usage

Add this to your `mix.exs`:

```Elixir
  def deps do
    [
      #...
      {:inverse_auth, github: "invrs/inverse_auth"},
      #...
    }
  end
```
