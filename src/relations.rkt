#lang racket

(require json racklog)

(define %category %empty-rel)

(define (read-json-wrapper filename)
    (call-with-input-file filename read-json))

(define (create-entity-category-relations list-of-files)
    (if (null? list-of-files)
        (void)
        (begin
          (let ()
            (define file-name (first list-of-files))
            (define data (read-json-wrapper file-name))
            (%assert! %category ()
                [((string->symbol (hash-ref data 'entity_alias)) 
                  (string->symbol (hash-ref data 'category)))])
            (create-entity-category-relations (list-tail list-of-files 0))))))

(create-entity-category-relations 
    (map path->string (directory-list "./data/flavordb/" #:build? #t)))

(%which ()
    (%category 'bread 'bakery))
