#lang racket

; Carrega bibliotecas
(require net/url)
(require html)

; Renomeia as bibliotecas para evitar conflitos de nome
; entre as funções e símbolos 
(require (prefix-in h: html)
         (prefix-in x: xml))

; Extrai conteúdo HTML de uma página e converte em string 
(define an-html
  (h:read-xhtml
   (open-input-string
    (string-append (bytes->string/utf-8 (port->bytes (get-pure-port (string->url "https://docs.racket-lang.org/sxml-intro/index.html")))))
    )
  )
)

; Define uma função que recebe o conteúdo HTML e retorna lista de strings
; A função extract-pcdata-from-element é chamada recursivamente para processar os elementos
(define (extract-pcdata some-content)
  (cond 
   [(x:pcdata? some-content)
    (list (x:pcdata-string some-content))]
   [(x:entity? some-content) (list)]
   [else
    (extract-pcdata-from-element some-content)]
  )
)

; Verificação do HTML e concatenação de todas as listas
; Percore extrutura hierárquica do HTML
(define (extract-pcdata-from-element an-html-element)
  (match an-html-element
    [(struct h:html-full (attributes content))
     (apply append (map extract-pcdata content))]
    [(struct h:html-element (attributes))
     '()]
  )
)

; Filtra listas que contém apenas uma string
(define filtered-list
  (filter (lambda (str)
            (> (length (string-split str)) 1))
          (extract-pcdata an-html))
)

; Função que gera HTML das listas filtradas
(define output-html
  (string-append
   "<html>"
   "<head><title>Resultado do Web Scraping</title></head>"
   "<div align='center'><h2>🖤 Verifique o web scraping criado 🖤</h2></div>"
   "<body>"
   "<div>" (apply string-append (map (lambda (str) (string-append "<p>" str "</p>")) filtered-list)) "</div>"
   "</body>"
   "</html>"
  )
)

; Nome do arquivo de saída
(define output-file "output.html")

; Verifica se o arquivo de saída já existe
(if (file-exists? output-file)
    (printf "O arquivo de saída já existe\n")
    (begin
      ; Escreve o conteúdo HTML no arquivo de saída
      (call-with-output-file output-file
        (lambda (out-port)
          (display output-html out-port))
      )
      
      (printf "O resultado foi salvo no arquivo ~a\n" output-file)
    )
)

; Chama o HTML gerado, sem filtros
; (printf "~s\n" (extract-pcdata an-html))
 
; Exibe o HTML com o filtro 
;(printf "~s\n" filtered-list)