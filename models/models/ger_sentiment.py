import torch
import germansentiment
import json

# Initialize the model
model = germansentiment.SentimentModel()

# Dummy input that matches the input dimensions of the model
dummy_input = torch.randint(0, 30_000, (1, 512), dtype=torch.long)

# Export to ONNX
torch.onnx.export(model.model, dummy_input, "german_sentiment_model.onnx")

# Export the vocab
with open('vocab.json', 'w') as f:
    json.dump(model.tokenizer.vocab, f)

