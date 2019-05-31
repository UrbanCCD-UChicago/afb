defmodule Afb.Repo.Seeds do
  alias Afb.DataSet.DataSet

  def seed_data_sets do
    {:ok, _} = DataSet.create "Syracuse", "syracuse", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Syracuse.complete.latest.tar"
    {:ok, _} = DataSet.create "Denver", "denver", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Denver.complete.latest.tar"
    {:ok, _} = DataSet.create "Chicago", "chicago", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Chicago.complete.latest.tar"
    {:ok, _} = DataSet.create "Stanford", "stanford", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Stanford.complete.latest.tar"
    {:ok, _} = DataSet.create "UNC", "unc", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_UNC.complete.latest.tar"
    {:ok, _} = DataSet.create "Portland", "portland", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Portland.complete.latest.tar"
    {:ok, _} = DataSet.create "UW", "uw", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_UW.complete.latest.tar"
    {:ok, _} = DataSet.create "Seattle", "seattle", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Seattle.complete.latest.tar"
    {:ok, _} = DataSet.create "NIU", "niu", "http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_NIU.complete.latest.tar"
    {:ok, _} = DataSet.create "GA Tech", "ga-tech", "https://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_GA_Tech.complete.latest.tar"
    {:ok, _} = DataSet.create "Vanderbilt", "vanderbilt", "https://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/AoT_Vanderbilt.complete.latest.tar"
  end
end

Afb.Repo.Seeds.seed_data_sets()
