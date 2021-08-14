(define-constant NOT_SATISFIED u0)
(define-map supply-chain {item-id: uint} {desc: (string-ascii 50), man: bool, pkg: bool, ship: bool, OUD: bool, del: bool})

(define-read-only (description (id uint))
    (unwrap-panic (get desc (map-get? supply-chain {item-id: id})))
)

(define-read-only (manufac (id uint))
    (unwrap-panic (get man (map-get? supply-chain {item-id: id})))
)

(define-read-only (packed (id uint))
    (unwrap-panic (get pkg (map-get? supply-chain {item-id: id})))
)

(define-read-only (shipped (id uint))
    (unwrap-panic (get ship (map-get? supply-chain {item-id: id})))
)

(define-read-only (outfordelivery (id uint))
    (unwrap-panic (get OUD (map-get? supply-chain {item-id: id})))
)

(define-read-only (delivered (id uint))
    (unwrap-panic (get del (map-get? supply-chain {item-id: id})))
)

(define-public (add_item (id uint) (des (string-ascii 50)))
    (if (is-eq (map-insert supply-chain {item-id: id} {desc: des, man: false, pkg: false, ship: false, OUD: false, del: false}) true)
        (ok "Successfully added to supply chain")
        (err "Can not add 2 items with same id")
    )
)

(define-public (change-man (id uint))
    (let (
            (x (description id))
        )
        
        (if (is-eq (map-set supply-chain {item-id: id} {desc: x, man: true, pkg: false, ship: false, OUD: false, del: false}) true)
            (ok "Item is manufactured.")
            (err "No such item exists with this id is on the Supply Chain.")
        )
    )
)

(define-public (change-pkg (id uint))
    (let (
            (x (description id))
            (y (manufac id))
        )
        (if (is-eq y true)
            (ok (map-set supply-chain {item-id: id} {desc: x, man: true, pkg: true, ship: false, OUD: false, del: false}))
            (err {kind: "Item hasn't been manufactured yet.", code: NOT_SATISFIED})
        )
    )
)

(define-public (change-ship (id uint))
    (let (
            (x (description id))
            (y (packed id))
        )
        (if (is-eq y true)
            (ok (map-set supply-chain {item-id: id} {desc: x, man: true, pkg: true, ship: true, OUD: false, del: false}))
            (err {kind: "Item hasn't been packed yet.", code: NOT_SATISFIED})
        )
    )
)

(define-public (change-OUD (id uint))
    (let (
            (x (description id))
            (y (shipped id))
        )
        (if (is-eq y true)
            (ok (map-set supply-chain {item-id: id} {desc: x, man: true, pkg: true, ship: true, OUD: true, del: false}))
            (err {kind: "Item hasn't been shipped yet.", code: NOT_SATISFIED})
        )
    )
)

(define-public (change-del (id uint))
    (let (
            (x (description id))
            (y (outfordelivery id))
        )
        (if (is-eq y true)
            (ok (map-set supply-chain {item-id: id} {desc: x, man: true, pkg: true, ship: true, OUD: true, del: true}))
            (err {kind: "Item isn't on the way.", code: NOT_SATISFIED})
        )
    )
)
