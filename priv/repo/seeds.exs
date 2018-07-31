defmodule Afb.Repo.Seeds do
  alias Afb.Auth.User

  alias Afb.DataSet.DataSet

  def seed_user do
    {:ok, _} = User.create "plenario@uchicago.edu", "password"
  end

  def seed_data_sets do
    {:ok, _} = DataSet.create %{name: "Syracuse Complete", slug: "syracuse-complete", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Syracuse.complete.latest.tar"}
    {:ok, _} = DataSet.create %{name: "Denver Complete", slug: "denver-complete", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Denver.complete.latest.tar"}
    {:ok, _} = DataSet.create %{name: "Chicago Complete", slug: "chicago-complete", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Chicago.complete.latest.tar"}
    {:ok, _} = DataSet.create %{name: "Stanford Complete", slug: "stanford-complete", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Stanford.complete.latest.tar"}
    {:ok, _} = DataSet.create %{name: "UNC Complete", slug: "unc-complete", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_UNC.complete.latest.tar"}
    {:ok, _} = DataSet.create %{name: "Detroit Complete", slug: "detroit-complete", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Detroit.complete.latest.tar"}
    {:ok, _} = DataSet.create %{name: "Portland Complete", slug: "portland-complete", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Portland.complete.latest.tar"}
    {:ok, _} = DataSet.create %{name: "UW Complete", slug: "uw-complete", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_UW.complete.latest.tar"}
    {:ok, _} = DataSet.create %{name: "Chicago Public", slug: "chicago-public", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Chicago.public.latest.tar"}
    {:ok, _} = DataSet.create %{name: "Seattle Complete", slug: "seattle-complete", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Seattle.complete.latest.tar"}
    {:ok, _} = DataSet.create %{name: "NIU Complete", slug: "niu-complete", source_url: "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_NIU.complete.latest.tar"}
  end
end

Afb.Repo.Seeds.seed_user()
Afb.Repo.Seeds.seed_data_sets()
