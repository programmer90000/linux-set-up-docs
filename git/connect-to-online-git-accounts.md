# GitHub

1. Go to `Settings > SSH and GPG keys`
2. Click `New SSH key`
3. Set the `Title` to `debian`
4. Set the `Key type` to `Authentication key`
5. Paste your public key
6. Run the following command to test the connection:
```
ssh -T git@github.com
```
You should recieve the message:
```
Hi programmer90000! You've successfully authenticated, but GitHub does not provide shell access.
```