from Crypto.Cipher import AES

# Define the plaintext and the key
plaintext = bytes.fromhex('00000000000000000000000000000000')
plaintext = bytes.fromhex('d3b930ac8979195ea7276b61dfe9d438')

key = bytes.fromhex('00000000000000000000000000000000')

# Create an AES cipher object with the key
cipher = AES.new(key, AES.MODE_ECB)

# Encrypt the plaintext
ciphertext = cipher.encrypt(plaintext)

# Print the ciphertext in hexadecimal format
print(ciphertext.hex())

