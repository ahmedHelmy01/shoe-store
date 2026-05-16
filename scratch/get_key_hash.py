import base64

sha1_hex = "A8:6A:41:B8:7F:ED:95:E8:52:4A:0A:86:77:D4:41:3D:76:F7:0B:45"
sha1_bytes = bytes.fromhex(sha1_hex.replace(":", ""))
key_hash = base64.b64encode(sha1_bytes).decode('utf-8')
print(key_hash)
