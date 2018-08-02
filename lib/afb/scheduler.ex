defmodule Afb.Scheduler do
  use Quantum.Scheduler, otp_app: :afb

  require Logger

  alias Afb.DataSet.DataSet

  def run do
    Logger.info("Checking S3 for new archives")
    DataSet.list()
    |> Enum.map(&Afb.process_bucket/1)

    Logger.info("Purging old slices")
    Afb.purge_old_slices()
  end
end
