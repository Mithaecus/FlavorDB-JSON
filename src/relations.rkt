#lang racket

(require racklog)

(require json)

(define %category %empty-rel)

(define (read-json-wrapper filename)
  (call-with-input-file filename read-json))

(define (create-entity-category-relations list-of-files)
    (begin
        (define file-name (first list-of-files))
        (define data (read-json-wrapper file-name))
        (%assert! %category ()
            [((string->symbol (hash-ref data 'entity_alias)) 
              (string->symbol (hash-ref data 'category)))])
        (%which ()
            (%category 'bread 'bakery))))

(create-entity-category-relations '("./data/flavordb/2.json"))
