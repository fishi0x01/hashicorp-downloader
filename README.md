# hashicorp-downloader

Simple Makefile to securely download Hashicorp tools.
Downloaded artifacts are verified through gpg signature and hashsum.

Set desired versions in top of `Makefile`.

```sh
make get-vault
make get-consul
make get-vagrant
make get-packer
make get-terraform
```
