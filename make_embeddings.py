from smartembed import SmartEmbed
from tqdm import tqdm
import pandas as pd


se = SmartEmbed()
dataset = pd.read_csv("./test_merged.csv")
embeddings = []
for code in tqdm(dataset['func_code']):
    contract = "pragma solidity ^0.4.19;\ncontract Cont {\n" +code +"\n}"
    vector = se.get_vector(contract)
    embeddings.append(vector)
dataset['embeddings'] = [e for e in embeddings]
dataset = dataset[['embeddings']]
dataset.to_csv("SmartEmbed_embeddings.pkl", index=False)
