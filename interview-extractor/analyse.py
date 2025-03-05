from collections import Counter
import pandas as pd
import matplotlib.pyplot as plt
from src.words import keep_only_nouns


DATA_PATH="white_house_speeches.csv"


def read_speech_data(path: str)->pd.DataFrame:
  """Reads the speech data from the given path and returns a pandas DataFrame"""
  return pd.read_csv(path)

def extract_speech_content(df: pd.DataFrame, row_idx: int = 0)->str:
  """Extracts the speech content from the DataFrame"""
  return df.loc[row_idx, "content"]


def split_speech_to_str_list(speech: str)->list[str]:
  """Splits the speech into a list of words"""
  return speech.split()


def prepare_data_for_frequency_analysis(path: str = DATA_PATH, use_nouns_only: bool = True):
  """Prepares the data for frequency analysis"""
  df = read_speech_data(path=path)

  analysis_str = ""
  for i, row in df.iterrows():

    if "unwanted string" in row["heading"]:
      print("unwanted string has been found for row: ", i, "skipping this row...")
      continue

    speech_content = extract_speech_content(df=df, row_idx=i)
    analysis_str += speech_content

  assert analysis_str != "", "No speech content found for analysis"

  speech_str_list = split_speech_to_str_list(speech=speech_content)
  
  # Remove unwanted words - nouns
  if use_nouns_only:
    speech_str_list = keep_only_nouns(speech_str_list)

  return speech_str_list

def run_frequency_analysis(speech_str_list: list[str])->dict:
  """"""
  # Word counter
  freq  = Counter(speech_str_list)

  # Use only the top 50 most frequent words
  freq = freq.most_common(50)

  plt.bar(range(len(freq)), [val[1] for val in freq], align='center')
  plt.xticks(range(len(freq)), [val[0] for val in freq], rotation=45)
  plt.xlabel('Items')
  plt.ylabel('Frequency')
  plt.title('Frequency Analysis')
  plt.show()




def main():
  data = prepare_data_for_frequency_analysis(path = DATA_PATH,use_nouns_only=False)
  run_frequency_analysis(data)


if __name__ == "__main__":
  main()