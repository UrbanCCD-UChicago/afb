defmodule Afb.Auth.AuthPipeline do

  use Guardian.Plug.Pipeline,
    otp_app: :afb,
    error_handler: Afb.Auth.ErrorHandler,
    module: Afb.Auth.Guardian

    # if there's a session token, validate it
    plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})

    # if there's a request header token, validate it
    plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})

    # load the user if either token is valid
    plug(Guardian.Plug.LoadResource, allow_blank: true)
end
