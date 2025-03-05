import nltk
from nltk.tag import pos_tag

nltk.download('averaged_perceptron_tagger')
nltk.data.path.append('/Users/petr/nltk_data')

def keep_only_nouns(words: list[str])->list[str]:
    """ Filters the input list and keeps only nouns """

    assert isinstance(words, list), "Input must be a list"
    assert all(isinstance(word, str) for word in words), "All elements in the list must be strings"

    tagged_words = pos_tag(words)  # POS tagging
    
    # Keep only words that are nouns
    nouns = [word for word, tag in tagged_words if tag in ('NN', 'NNS', 'NNP', 'NNPS')]
    
    return nouns
