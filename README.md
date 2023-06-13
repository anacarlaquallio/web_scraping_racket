# Web Scraping em Racket
Estudantes: Ana Carla Quallio rosa, Eduarda Martins, Maria Fernanda Pinelli.
Trabalho para a disciplina de Linguagens de Programação. Para executar testes, além da instalação do Racket, é preciso instalar os pacotes em linha de comando no terminal:

```
raco pkg install html
```

```
raco pkg install xml
```

```
raco pkg install sxml
```

```
raco pkg install html-parsing
```
Depois, só digitar racket caminho_arquivo_main.rkt no terminal.

## Paralelismo em Racket
Neste código, apesar de ser gerado em um mesmo arquivo HTML, a requisição do par URL e XPath é feito de forma sequencial. Porém, Racket permite paralelismo por meio da biblioteca racket/future. Uma possibilidade seria utilizar o paralelismo para fazer a requisição HTTP ao site, todavia o sincronismo deveria ser feito para a geração e escrita no arquivo resultado.html.
