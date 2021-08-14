(define-map supply-chain {item-id: uint} {desc: (string-ascii 50), man: bool, pkg: bool, ship: bool, OUD: bool, del: bool})

define-read-only (description (id uint))
    (get desc (map-get? supply-chain {item-id: id}))
)

(define-read-only (manufac (id uint))
    (get man (map-get? supply-chain {item-id: id}))
)

(define-read-only (packed (id uint))
    (get pkg (map-get? supply-chain {item-id: id}))
)

(define-read-only (shipped (id uint))
    (get ship (map-get? supply-chain {item-id: id}))
)

(define-read-only (outfordelivery (id uint))
    (get OUD (map-get? supply-chain {item-id: id}))
)

(define-read-only (delivered (id uint))
    (get del (map-get? supply-chain {item-id: id}))
)

(define-public (add_item (id uint) (des (string-ascii 50)))
    (ok (map-insert supply-chain {item-id: id} {desc: des, man: false, pkg: false, ship: false, OUD: false, del: false}))
)

(define-public (change-man (id uint))
    (let(
            (x (description id))
        )
        (ok (map-set supply-chain {item-id: id} {desc: x, man: true, pkg: false, ship: false, OUD: false, del: false}))
    )
)

(define-public (change-pkg (id uint))
    (let(
            (x (description id))
            (y (manufac id))
        )
        (if (is-eq y true)
        (ok (map-set supply-chain {item-id: id} {desc: x, man: true, pkg: true, ship: false, OUD: false, del: false}))
        (err u0)
        )
    )
)

(define-public (change-ship (id uint))
    (let(
            (x (description id))
            (y (packed id))
        )
        (if (is-eq y true)
        (ok (map-set supply-chain {item-id: id} {desc: x, man: true, pkg: true, ship: true, OUD: false, del: false}))
        (err u0)
        )
    )
)

(define-public (change-OUD (id uint))
    (let(
            (x (description id))
            (y (shipped id))
        )
        (if (is-eq y true)
        (ok (map-set supply-chain {item-id: id} {desc: x, man: true, pkg: true, ship: true, OUD: true, del: false}))
        (err u0)
        )
    )
)

(define-public (change-del (id uint))
    (let(
            (x (description id))
            (y (outfordelivery id))
        )
        (if (is-eq y true)
        (ok (map-set supply-chain {item-id: id} {desc: x, man: true, pkg: true, ship: true, OUD: true, del: true}))
        (err u0)
        )
    )
)