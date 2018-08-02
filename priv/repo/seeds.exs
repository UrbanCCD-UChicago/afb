defmodule Afb.Repo.Seeds do
  alias Afb.DataSet.DataSet

  def seed_data_sets do
    {:ok, _} = DataSet.create "Syracuse Complete", "syracuse-complete", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Syracuse.complete.latest.tar"
    {:ok, _} = DataSet.create "Denver Complete", "denver-complete", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Denver.complete.latest.tar"
    {:ok, _} = DataSet.create "Chicago Complete", "chicago-complete", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Chicago.complete.latest.tar"
    {:ok, _} = DataSet.create "Stanford Complete", "stanford-complete", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Stanford.complete.latest.tar"
    {:ok, _} = DataSet.create "UNC Complete", "unc-complete", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_UNC.complete.latest.tar"
    {:ok, _} = DataSet.create "Detroit Complete", "detroit-complete", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Detroit.complete.latest.tar"
    {:ok, _} = DataSet.create "Portland Complete", "portland-complete", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Portland.complete.latest.tar"
    {:ok, _} = DataSet.create "UW Complete", "uw-complete", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_UW.complete.latest.tar"
    {:ok, _} = DataSet.create "Chicago Public", "chicago-public", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Chicago.public.latest.tar"
    {:ok, _} = DataSet.create "Seattle Complete", "seattle-complete", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Seattle.complete.latest.tar"
    {:ok, _} = DataSet.create "NIU Complete", "niu-complete", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_NIU.complete.latest.tar"
  end
end

Afb.Repo.Seeds.seed_data_sets()
