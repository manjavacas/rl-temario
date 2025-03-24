#import "@preview/polylux:0.3.1": *
#import themes.metropolis: *

// ******************************* CONFIGURATION *******************************

#show: metropolis-theme.with()

#show math.equation: set text(font: "Fira Math")

#set text(font: "Fira Sans", size: 20pt, hyphenate: false)
#set par(justify: true)
#set strong(delta: 100)

// ***************************** CUSTOM ELEMENTS ******************************

#let frame(content, title: none) = {
  let header = [#text(fill: white, title)]

  set block(stroke: black, width: 100%, inset: (x: 0.5em, top: 0.4em, bottom: 0.5em))
  show stack: set block(breakable: false)
  show stack: set block(breakable: false, above: 0.8em, below: 0.5em)

  stack(
    block(fill: m-dark-teal, radius: (top: 0.2em, bottom: 0cm), header),
    block(fill: m-extra-light-gray, radius: (top: 0cm, bottom: 0.2em), content),
  )
}

#let definition(content, title: none) = {
  frame(content, title: title)
}

#let shadow(content) = {
  block(fill: luma(240), inset: 12pt, radius: 4pt)[
    #content
  ]
}

#let colmath(x, color) = text(fill: color)[$#x$]

// *****************************************************************************

#title-slide(
  author: [Antonio Manjavacas Lucas],
  title: "Aprendizaje por refuerzo",
  subtitle: "Métodos basados en muestreo (2)",
  extra: "manjavacas@ugr.es",
)

// *****************************************************************************

#slide(title: "Índice")[
  #metropolis-outline
]

// *****************************************************************************

#let on = text[Métodos _on-policy_]
#let off = text[Métodos _off-policy_]

#slide(title: "Control MC sin inicios de exploración")[

  #text(size: 19pt)[
    Vamos a estudiar dos alternativas a MC con inicios de exploración:

    #pause

    #frame(title: [#on])[
      #emoji.silhouette Se emplea #alert[*una única política*] que mejora progresivamente, permitiendo siempre cierta exploración.

      - Mejoran y evalúan constantemente la misma política.
    ]

    #pause

    #frame(title: [#off])[
      #emoji.silhouette.double El agente aprende una *política objetivo* (#alert[*_target policy_*]) a partir de datos generados por otra *política exploratoria* (#alert[*_behaviour policy_*]).

      - La política que empleamos para aprender/explorar "está fuera" (_off_) de la que empleamos para seleccionar acciones.
    ]
  ]

]

#new-section-slide([#on])

// *****************************************************************************

#slide(title: [#on])[

  #box(height: 400pt)[
    #columns(2)[
      #shadow[Los métodos #emoji.silhouette #alert[*_on-policy_*] emplean *una única política*.]


      #text(
        size: 18pt,
      )[Esta política _aspira_ a un comportamiento óptimo, pero siempre debe reservar *cierta probabilidad de explorar*.]

      Las políticas empleadas generalmente son #alert[_soft_] ("suaves"), es decir:
      #v(0.3cm)

      #align(center)[
        #shadow[$ pi(a|s) > 0 #h(1cm) forall s in cal(S), a in cal(A) $]
      ]
      #colbreak()
      #align(center)[#image("images/on-policy.png", width: 85%)]
    ]

  ]
]

// *****************************************************************************

#slide(title: [#on])[
  #align(center)[
    MC con inicios de exploración es _on-policy_ $dots$

    #pause

    #h(1cm) $dots$ aunque poco viable, como hemos adelantado.

    #v(1cm)

    #pause

    #shadow[Una opción más apropiada son las #alert[*políticas $epsilon$-_greedy_*].]
  ]
]

// *****************************************************************************

#let greed = text[Políticas $epsilon$-_greedy_]
#let egreed = text[$epsilon$-_greedy_]

#slide(title: [#greed])[
  #shadow[Las políticas #alert[#egreed] son políticas estocásticas que siempre permiten cierta probabilidad $epsilon > 0$ de explorar.]

  #columns(2)[
    #align(center)[#image("images/egreedy.png")]
    #colbreak()
    La #alert[acción _greedy_] es aquella que se elige con mayor probabilidad.

    Eventualmente, el resto de acciones (no óptimas) podrían explorarse con probabilidad $epsilon$.

    - El valor de $epsilon$ puede reducirse gradualmente, hasta que la política sea prácticamente determinista.
  ]
]

// *****************************************************************************

#let soft = text[Políticas $epsilon$-_soft_]
#let esoft = text[$epsilon$-_soft_]

#slide(title: [#soft])[

  #shadow[#egreed es un subconjunto de las políticas conocidas como #alert[#esoft.]]

  #v(1cm)

  #columns(2)[
    #align(center)[#image("images/esoft.png", width: 100%)]

    #colbreak()

    Siempre permiten cierta exploración.

    En el caso de #egreed: $ pi(a|s) >= epsilon/(|A(s)|) $

  ]
]

// *****************************************************************************

#slide(title: [#soft])[

  - Si $epsilon > 0$ estas políticas nunca pueden ser óptimas. Esto se debe a que *siempre existe cierta probabilidad de realizar acciones sub-óptimas* (explorar).

  - No convergen en una política óptima, pero sí en una #alert[muy aproximada]. Además, evitan emplear inicios de exploración.

  #v(1cm)
  #align(center)[#image("images/on-policy-exp.png", width: 30%)]
]

// *****************************************************************************

#slide(title: [#on])[
  #align(center)[
    #box(height: 500pt)[
      #image("images/on-algo.png", width: 80%)
    ]
  ]
]

// *****************************************************************************

#let onlim = text[Limitaciones de los métodos _on-policy_]

#slide(title: [#onlim])[

  #box(height: 500pt)[

    #columns(2)[

      #v(1cm)
      #shadow[#emoji.quest ¿Existe alguna #alert[alternativa] a mantener siempre cierta probabilidad de explorar?]

      MC _on-policy_ supone aprender una política *muy cercana a la óptima*, pero siempre existe cierta probabilidad de elegir acciones sub-óptimas.

      #shadow[Los métodos #emoji.silhouette.double #alert[_off-policy_] son una alternativa.]

      #colbreak()

      #align(center)[
        #image("images/onp.png", width: 55%)
      ]

      #align(center)[
        #image("images/offp.png", width: 70%)
      ]
      #v(0.5cm)
    ]

  ]
]

// *****************************************************************************

#new-section-slide([#off])

// *****************************************************************************

#slide(title: [#off])[

  #shadow[Los métodos #emoji.silhouette.double #alert[*_off-policy_*] hacen uso de *dos políticas*:]

  1. #text(fill:green)[*Política objetivo*] (_target policy_). Destinada a ser óptima.

  2. #text(fill:blue)[*Política de comportamiento*] (_behaviour policy_). Política exploratoria empleada para "generar comportamiento" (muestrear, acumular experiencia).

    En este caso, decimos que #alert[el aprendizaje de la política óptima se hace a partir de datos/resultados "fuera" (_off_) de la política objetivo].

    - Es decir, mediante información obtenida por la política de comportamiento.

]

// *****************************************************************************

#slide(title: [#off])[
  #align(center)[#image("images/on-off-example.png", width: 80%)]
]


// *****************************************************************************

#let offon = text[Ejemplo. _On-policy_ vs. _Off-policy_]

#slide(title: [#offon])[

  #box(height: 400pt)[
    #columns(2)[
      #shadow[#emoji.silhouette #h(0.2cm) _On-policy_]
      #text(size: 17pt)[
        Imagina que tienes un restaurante favorito al que sueles ir a comer (#alert[acción _greedy_]).

        - Al principio, es posible que tu criterio no sea muy preciso pero, a medida que visitas todos los restaurantes varias veces, cada vez repites más el mismo.

        Algunos días vuelves a otros restaurantes que consideras peores para ver si la calidad ha mejorado (#alert[exploración]).

        - Eventualmente estás abierto a dar una nueva oportunidad a restaurantes peores.

        #v(1.2cm)

        #colbreak()

        #v(1.5cm)

        #align(center)[
          #image("images/on-rest.png", width: 70%)
        ]


      ]
    ]
  ]

]

// *****************************************************************************

#let offon2 = text[_On-policy_ vs. _Off-policy_]

#slide(title: [#offon])[

  #box(height: 400pt)[

    #shadow[#emoji.silhouette.double #h(0.2cm) _Off-policy_]
    #text(size: 17pt)[

      Dejas que otra persona pruebe todos los restaurantes de la ciudad durante un tiempo (#alert[política de comportamiento]). En base a su experiencia, eliges ir siempre al restaurante que te recomiende (#alert[política objetivo]).

      - Tú no pruebas nuevos restaurantes (no exploras), lo hace alguien por ti.

      #align(center)[
        #image("images/off-rest.png", width: 65%)
      ]

    ]
  ]

]

// *****************************************************************************

#slide(title: [#offon2])[

  #shadow[#emoji.silhouette Los métodos *_on-policy_* son más simples, porque sólo se requiere una política.]

  #shadow[#emoji.silhouette.double Los métodos *_off-policy_* requieren más tiempo para converger y presentan una mayor varianza (cambios de comportamiento más bruscos).]

  #text(size: 17pt)[
    - No obstante, son más potentes y generales.

    - De hecho, #alert[son una generalización de los métodos _on-policy_], en el caso concreto en que las políticas objetivo y de comportamiento sean las mismas.
  ]

  #shadow[#emoji.lightbulb Los métodos _off-policy_ suelen emplearse para aprender a partir de datos generados por un controlador reactivo o por humanos.]

]

// *****************************************************************************

#slide(title: [#off])[

  #shadow[*_¿Cuándo es preferible el aprendizaje off-policy?_*]

  - Aprendizaje a partir de datos generados por #text(fill:red)[humanos u otros agentes].
  - Aprendizaje a partir de la experiencia generada por #text(fill:blue)[políticas anteriores].
    - Reutilización de experiencia proveniente de versiones anteriores de la misma política.
  - Aprendizaje de una política óptima #text(fill:green)[determinista empleando otra política exploratoria].
  - Aprendizaje a partir de la experiencia de #text(fill:purple)[múltiples políticas combinadas].

]

// *****************************************************************************

#let predoff = text[Predicción _off-policy_]

#focus-slide([#predoff])

// *****************************************************************************

#slide(title: [#predoff])[

  #shadow[#alert[*Objetivo*]: estimar $v_pi$ o $q_pi$ dadas las políticas $pi$ (objetivo) y $b$ (comportamiento).]

  Si queremos emplear episodios de $b$ para estimar valores para $pi$, es necesario que cada acción tomada por $b$ la pueda tomar también $pi$ (al menos, eventualmente).

  Denominamos a esto #alert[*supuesto de cobertura*]:

  $ "Si" pi(a|s) > 0, "entonces" b(a|s) > 0 $

  - $b$ es una política *estocástica* (no tiene por qué serlo al 100%, puede ser $epsilon$-_greedy_).
  - $pi$ puede ser *determinista* o *estocástica*.

]

// *****************************************************************************

#slide(title: "Políticas objetivo estocásticas")[

  #box(height: 400pt)[
    #columns(2)[

      #v(4.5cm)

      Generalmente consideraremos políticas objetivo $pi$ *deterministas*.

      Aunque existen problemas donde puede ser útil que $pi$ sea *estocástica*.

      #colbreak()

      #align(center)[
        #image("images/pi-policy.png")
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Políticas objetivo estocásticas")[
  #align(center)[
    #image("images/pi-policies.png")
  ]
]

// *****************************************************************************

#slide(title: "Políticas de comportamiento estocásticas")[

  #box(height: 400pt)[
    #columns(2)[

      #shadow[_¿Para qué una #alert[*política objetivo $pi$ estocástica?*]_]

      En este ejemplo, si $pi$ es *determinista* sólo contemplará una acción por estado, incluso si hay varias acciones óptimas.

      Pero si es *estocástica*, tenemos una política que permite una #alert[mayor variedad de acciones óptimas] para un mismo estado.

      #colbreak()

      #v(0.1cm)
      #align(center)[
        #image("images/pi-policies.png", width: 120%)
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: [#off])[

  Sea como sea la política objetivo $pi$, estamos tratando de obtener $v_pi (s)$ #alert[a partir de experiencia generada por una política $b$ diferente]. Es decir, lo que tenemos es:

  $ v_b (s) = EE [G_t | S_t=s] $

  #shadow[El #text(fill:red)[problema] es que las distribuciones de estados y acciones bajo $b$ y $pi$ pueden ser diferentes, dando lugar a un #alert[*sesgo*].]

  Si un subconjunto de estados es más frecuente siguiendo $b$, entonces $pi$ únicamente contará con información sobre esos estados, ignorando el resto.

  #emoji.lightbulb Una forma de solucionar esto es emplear #alert[_*importance sampling*_].

]

// *****************************************************************************

#let imp = text[_Importance sampling_]

#focus-slide([#imp])

// *****************************************************************************

#slide(title: [#imp])[

  #frame(title: [#imp])[
    El #alert[muestreo por importancia], o *_importance sampling_* es una técnica empleada en estadística para estimar el valor esperado de una distribución en base a ejemplos muestreados de una distribución diferente.
  ]

  #v(1cm)

  Veamos de forma intuitiva en qué consiste...

]

// *****************************************************************************

#slide(title: [#imp])[
  Quiero obtener: $ EE[g(X)] $

  Genero muestras aleatorias de una distribución: $ X_1, X_2, dots, X_n tilde.op cal(D) $

  Aproximo el valor esperado con Monte Carlo: $ EE[g(X)] tilde.eq frac(1,n) sum^n_(i=1) g(X_i) $
]

// *****************************************************************************

#slide(title: [#imp])[

  #box(height: 400pt)[
    Valores de $g(X)$ podrían ser *poco probables* pero con una *contribución muy significativa* sobre $EE[g(X)]$.

    Si no se _samplean_ durante la estimación Monte Carlo, $EE[g(X)]$ se estimará mal.

    #shadow[El #alert[muestreo por importancia] consiste en emplear una distribución "_modificada_" donde los valores más importantes (los que más afectan a la estimación de $EE[g(X)]$) se vuelven *más probables*.]

    Aseguramos así que sean muestreados y formen parte de la estimación Monte Carlo de $EE[g(X)]$.

    Para paliar el efecto de este aumento de probabilidad, los valores se escalan dándoles un menor peso al ser muestreados.
  ]
]


// *****************************************************************************

#slide(title: [#imp])[
  Muestreamos valores que provienen de la distribución _modificada_:

  $ Y_1, Y_2, dots, Y_n tilde.op cal(D') $

  Y aproximamos de la siguiente manera:

  $ EE[g(Y)] = frac(1,n) sum^n_(i=1) frac(p_cal(D) (Y_i), p_cal(D') (Y_i)) g(Y_i) $

  Siendo: $ EE[g(Y)] tilde.eq EE[g(X)] $

]


// *****************************************************************************

#slide(title: [#imp])[
  #align(center)[
    #box(height: 400pt)[
      #image("images/importance-sampling-example.png")
    ]
  ]
]


// *****************************************************************************

#slide(title: [#imp])[

  _Intuitivamente_:

  - #text(fill:blue)[Ampliamos] (_scale up_) los eventos que son raros en $cal(D')$ pero comunes en $cal(D)$.

  - #text(fill:red)[Reducimos] (_scale down_) los eventos que son comunes en $cal(D')$ pero raros en $cal(D)$.

  $ EE[g(Y)] = frac(1,n) sum^n_(i=1) frac(p_cal(D) (Y_i), p_cal(D') (Y_i)) g(Y_i) $

]

// *****************************************************************************

#slide(title: [#imp])[

  $ EE[g(Y)] = frac(1,n) sum^n_(i=1) frac(p_cal(D) (Y_i), p_cal(D') (Y_i)) g(Y_i) $

  #text(size: 18pt)[
    #table(
      columns: 2,
      inset: 10pt,
      fill: (x, y) => if x == 0 { gray.lighten(75%) },
      [$frac(p_cal(D) (Y_i), p_cal(D') (Y_i))$ = 1],
      [Misma probabilidad en $cal(D)$ y $cal(D')$. La aportación no varía.],

      [$frac(p_cal(D) (Y_i), p_cal(D') (Y_i))$ > 1],
      [$Y_i$ es más probable en la distribución original $cal(D)$, por lo que su peso es mayor.],

      [$frac(p_cal(D) (Y_i), p_cal(D') (Y_i))$ < 1],
      [$Y_i$ es más probable en la distribución modificada $cal(D')$, por lo que su peso es menor.],

      [$frac(p_cal(D) (Y_i), p_cal(D') (Y_i))$ = 0],
      [$Y_i$ no aporta nada, porque no puede obtenerse en la distribución original.],

      [$p_cal(D') (Y_i)$ = 0], [No se cumple el principio de cobertura.],
    )
  ]
]

// *****************************************************************************

#let impoff = text[¿Cómo se aplica en predicción _off-policy_?]

#focus-slide([#impoff])

// *****************************************************************************

#let predoffimp = text[Predicción _off-policy_ con _importance sampling_]

#slide(title: [#predoffimp])[

  #box(height: 400pt)[
    #columns(2)[

      #v(2.8cm)

      Recordemos el concepto de #alert[*trayectoria*]:

      $ tau = {S_t, A_t, S_(t+1), A_(t+1), dots, S_T} $

      La #alert[*probabilidad* de realizar una trayectoria $tau$ bajo una política $pi$] es:

      $ "Prob"(tau_pi) = product^(T-1)_(k=t) pi(A_k|S_k) #h(0.1cm) p(S_(k+1) | S_k, A_k) $

      #colbreak()

      #align(center)[#image("images/trajectory.png")]
    ]

  ]


]

// *****************************************************************************

#slide(title: [#predoffimp])[
  #box(height: 400pt)[
    #shadow[_¿Cómo de probable es seguir una trayectoria bajo la política $pi$ con respecto a la probabilidad de seguirla bajo la política $b$?_]

    Esto viene dado por el #alert[*_importance sampling ratio_*]:

    $
      rho_(t:T-1) = frac("Prob"(tau_pi), "Prob"(tau_b)) = frac(product^(T-1)_(k=t) pi(A_k|S_k) #h(0.1cm) p(S_(k+1) | S_k, A_k), product^(T-1)_(k=t) b(A_k|S_k) #h(0.1cm) p(S_(k+1) | S_k, A_k))
    $

    *Las dinámicas del MDP no influyen*:

    $
      rho_(t:T-1) = frac("Prob"(tau_pi), "Prob"(tau_b)) = frac(product^(T-1)_(k=t) pi(A_k|S_k) #h(0.1cm) cancel(p(S_(k+1) | S_k, A_k)), product^(T-1)_(k=t) b(A_k|S_k) #h(0.1cm) cancel(p(S_(k+1) | S_k, A_k))) = frac(product^(T-1)_(k=t) pi(A_k|S_k), product^(T-1)_(k=t) b(A_k|S_k) #h(0.1cm))
    $
  ]
]

// *****************************************************************************

#slide(title: [#predoffimp])[
  #box(height: 400pt)[

    Utilizamos $rho$ para #alert[ponderar las recompensas finales] obtenidas en cada trayectoria.

    #table(
      columns: 2,
      fill: (x, y) => if x == 0 { gray.lighten(70%) },
      inset: 10pt,
      [$rho$ = 1], [El valor de $G$ obtenido se mantiene, ya que es igual de probable con $b$ y $pi$.],
      [$rho$ > 1], [El valor de $G$ obtenido por $b$ tiene mayor peso, porque es una trayectoria probable con $pi$.],
      [$rho$ < 1], [El valor de $G$ obtenido por $b$ se reduce porque es una trayectoria poco probable con $pi$.],
      [$rho$ = 0], [El valor de $G$ se anula porque no es una trayectoria que podamos obtener con $pi$.],
    )

  ]
]

// *****************************************************************************

#slide(title: [#predoffimp])[

  Finalmente, lo que tenemos es:

  #let a = text(fill: red, size: 17pt)[Retorno obtenido\ tras una serie\ de trayectorias\ siguiendo $b$]
  #let b = text(fill: blue, size: 17pt)[Función de valor\ correspondiente a\ la política objetivo $pi$]

  #text(size: 27pt)[
    #align(center)[
      #alternatives(position: center + horizon)[
        $EE[rho_(t:T-1) G_t | S_t = s] = v_pi (s)$
      ][
        $EE[$$underbrace(rho_(t:T-1) G_t, #a)$$| S_t = s] = underbrace(v_pi (s), #b)$
      ][
        $EE[$$underbrace(rho_(t:T-1) G_t, #a)$$| S_t = s] = underbrace(v_pi (s), #b)$

        #text(size: 20pt)[
          #shadow[Ponderamos la recompensa acumulada obtenida\ tras una trayectoria en base a su probabilidad.]
        ]
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  La política $b$ interactúa con el entorno durante un episodio y obtiene un retorno $G = 10$.

  #shadow[
    Si la trayectoria seguida por $b$ es 3 veces *menos* probable que ocurra empleando $pi$, aumentamos $G times 3$:
  ]

  $ pi(a|s) > b(a|s) #h(0.2cm) ("ej." times 3) --> G = 10 times 3 = 30 $

  #shadow[
    Si, por el contrario, es *más* probable que ocurra en $b$ que en $pi$, reducimos el valor de G:
  ]

  $ pi(a|s) < b(a|s) #h(0.2cm) ("ej." times 0.25) --> G = 10 times 0.25 = 2.5 $

]

// *****************************************************************************

#let predmcimpt = text[Predicción Monte Carlo de $v_pi$\ con _importance sampling_]

#focus-slide([#predmcimpt])

// *****************************************************************************

#let predmcimp = text[Predicción MC de $v_pi$ con _importance sampling_]

#slide(title: [#predmcimp])[

  #box(height: 500pt)[

    Dado un conjunto (_batch_) de episodios observados a partir de una política _b_, procedemos a estimar $v_pi$. Tenemos dos opciones:

    - _Importance sampling_ #alert[*ordinario*]:

    $ V(s) = frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, |cal(T) (s)|) $

    - _Importance sampling_ #alert[*ponderado*]:

    $ V(s) = frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, sum_(t in cal(T)(s)) rho_(t:T(t)-1)) $

  ]

]

// *****************************************************************************

#let predmcimpord = text[Predicción MC de $v_pi$ con _importance sampling_ ordinario]

#slide(title: [#predmcimpord])[

  $ V(s) = frac(sum_(t in cal(T)(s)) colmath(rho_(t:T(t)-1), #olive) colmath(G_t, #red), colmath(|cal(T) (s)|, #blue)) $

  #v(1cm)

  #text(fill: olive, size: 18pt)[
    - $t$ = _time step_ donde se visita $s$.
    - $T(t)$ = siguiente terminación de episodio tras $t$.
  ]

  #text(fill: red, size: 18pt)[
    - Retorno obtenido al final de la trayectoria.
  ]

  #text(fill: blue, size: 18pt)[
    - _Time steps_ en los que se ha visitado _s_.
  ]

]

// *****************************************************************************

#slide(title: [#predmcimpord])[

  $ V(s) = frac(sum_(t in cal(T)(s)) colmath(rho_(t:T(t)-1), #olive) colmath(G_t, #red), colmath(|cal(T) (s)|, #blue)) $

  #v(1cm)

  - #alert[*_First-visit_*]: $cal(T)(s)$ sólo considera los _time steps_ de la primera visita a $s$ en cada episodio.

  - #alert[*_Every-visit_*]: $cal(T)(s)$ incluye todas las visitas a $s$.

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #text(size: 17pt)[
    $
      V(s) = frac(sum_(t in cal(T)(s)) colmath(rho_(t:T(t)-1), #black) colmath(G_t, #black), colmath(|cal(T) (s)|, #black))
    $
  ]

  #text(size: 13pt)[
    _Batch_ de 2 episodios:
  ]

  #align(center)[#image("images/is-mc-ord.png")]

  #columns(2)[

    #align(center)[#shadow[#alert[*_First-visit_*]: $cal(T)(s) = {1,7}$]]

    $ V(s) = frac(rho_(1:3) dot 10 + rho_(7:10) dot 5, 2) $

    #colbreak()

    #align(center)[#shadow[#alert[*_Every-visit_*]: $cal(T)(s) = {1,7,9}$]]

    $ V(s) = frac(rho_(1:3) dot 10 + rho_(7:10) dot 5 + rho_(9:10) dot 5, 3) $

  ]

]

// *****************************************************************************

#slide(title: "Limitaciones")[

  El* _importance sampling_ ordinario* no presenta sesgos (_bias_) en favor de la política de comportamiento $b$, #text(fill:red)[pero puede ser demasiado extremo].

  #shadow[Por ejemplo, si una trayectoria es $times 10$ veces más probable bajo $pi$ que bajo $b$, la estimación será diez veces $G$, que se aleja bastante del realmente observado.]

  Se plantea como alternativa el *_importance sampling_ ponderado*:

  $ V(s) = frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, sum_(t in cal(T)(s)) rho_(t:T(t)-1)) $
]

// *****************************************************************************

#slide(title: "Limitaciones")[

  #align(center)[#image("images/ord-imp-examp.png")]

]

// *****************************************************************************

#let predmcimppon = text[Predicción MC de $v_pi$ con _importance sampling_ ponderado]

#slide(title: [#predmcimppon])[

  $ V(s) = frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, sum_(t in cal(T)(s)) rho_(t:T(t)-1)) $

  - Presenta mayor sesgo:
    - Si sólo se visita un estado una vez, $v_pi (s) = v_b (s)$, el _importance sampling ratio_ se cancela y hay un sesgo hacia la política de comportamiento.

  - Sin embargo, la varianza es menor (actualizaciones menos extremas).

  - Suele ser una mejor opción #emoji.checkmark.box
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #text(size: 14pt)[
    $ V(s) = frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, sum_(t in cal(T)(s)) rho_(t:T(t)-1)) $
  ]

  #text(size: 12pt)[
    _Batch_ de 2 episodios:
  ]

  #align(center)[#image("images/is-mc-ord.png")]

  #columns(2)[

    #align(center)[#shadow[#alert[*_First-visit_*]: $cal(T)(s) = {1,7}$]]

    $ V(s) = frac(rho_(1:3) dot 10 + rho_(7:10) dot 5, rho_(1:3) + rho_(7:10)) $

    #colbreak()

    #align(center)[#shadow[#alert[*_Every-visit_*]: $cal(T)(s) = {1,7,9}$]]

    $ V(s) = frac(rho_(1:3) dot 10 + rho_(7:10) dot 5 + rho_(9:10) dot 5, rho_(1:3) + rho_(7:10) + rho_(9:10)) $

  ]

]

// *****************************************************************************

#slide(title: "Comparativa")[

  #align(center)[#image("images/example-is.png")]

]

// *****************************************************************************

#focus-slide("Predicción Monte Carlo incremental")

// *****************************************************************************

#slide(title: "Predicción MC incremental")[

  La predicción Monte Carlo puede realizarse de forma #alert[*incremental*].

  - Supongamos una secuencia de retornos: $G_1, G_2, dots, G_(n-1)$ obtenidos partiendo de un mismo estado.

  - Cada retorno tiene una ponderación $W_i = rho_(t_i:T (t_i)-1)$

  - Empleando _importance sampling_ ponderado tenemos:

  $ V_n = frac(sum_(k=1)^(n-1) W_k G_k, sum_(k=1)^(n-1) W_k), #h(1cm) n >= 2 $

]

// *****************************************************************************

#slide(title: "Predicción MC incremental")[

  #box(height: 400pt)[
    #text(size: 17pt)[

      $ V_n = frac(sum_(k=1)^(n-1) W_k G_k, sum_(k=1)^(n-1) W_k), #h(1cm) n >= 2 $

      Buscamos #alert[actualizar incrementalmente $V_n$] cada vez que se obtiene un nuevo retorno $G_n$.

      - Para cada estado consideramos $C_n$, que es la suma acumulada de los pesos de los $n$ primeros retornos:

        $ C_(n+1) = C_n + W_(n+1) $

      - El cálculo de $W_(n+1)$ es recursivo:

        #text(size: 16pt)[
          $ W_1 <- rho_(T-1) $
          $ W_2 <- rho_(T-1) rho_(T-2) $
          $ W_3 <- rho_(T-1) rho_(T-2) rho_(T-3) $
          $ dots $
          $ W_(n+1) <- W_n rho_n $
        ]

    ]
  ]
]


// *****************************************************************************

#slide(title: "Predicción MC incremental")[

  #box(height: 400pt)[

    Así, la *regla de actualización* empleada es:

    #v(1cm)

    $ V_(n+1) = V_n + frac(W_n, C_n)[G_n - V_n], #h(1cm) n >= 1 $

    #v(1cm)

    _$V$ puede ser el valor de un estado o de un par acción-estado._

    #v(1cm)

    #shadow[Si bien esta implementación se corresponde con el algoritmo de #alert[predicción _off-policy_ con _importance sampling_ ponderado], también se aplica al caso #alert[_on-policy_] si $pi = b$ ($W$ es siempre $=1$).]

  ]
]

// *****************************************************************************

#slide(title: "Predicción MC incremental")[
  #align(center)[#box(height: 400pt)[
      #image("images/MC-off-inc.png")
    ]]
]

// *****************************************************************************

#let conoff = text[Control Monte Carlo _off-policy_]

#focus-slide([#conoff])

// *****************************************************************************

#slide(title: [#conoff])[
  #align(center)[#box(height: 400pt)[
      #image("images/MC-control-off.png")
    ]]
]

// *****************************************************************************

#focus-slide("Resumiendo...")

// *****************************************************************************

#slide(title: "Resumiendo...")[
  #box(height: 400pt)[

    - Los métodos #alert[*Monte Carlo*] aprenden funciones de valor y políticas óptimas a partir de experiencia procedente de #alert[*episodios muestreados / aleatorios*].

    #pause

    - Las políticas óptimas se aprenden directamente, #alert[*sin requerir un modelo del entorno*] ni emplear _bootstrapping_ (estimaciones a partir de estimaciones).

    #pause

    - El esquema general de #alert[*GPI*] también se aplica a estos métodos (evaluación + mejora de la política).

    #pause

    - La aproximación de las funciones de valor se realiza en base al #alert[*retorno promedio*] desde cada estado.

  ]
]

// *****************************************************************************

#slide(title: "Resumiendo...")[
  #box(height: 400pt)[

    - Para garantizar la exploración, empleamos técnicas como #alert[*inicios de exploración*], aunque presenta algunas limitaciones.

    #pause

    - Los métodos #alert[*_on-policy_*] permiten asegurar la exploración y alcanzar una política muy cercana a la óptima.

    #pause

    - Los métodos #alert[*_off-policy_*] emplean dos políticas: una para explorar, y otra para actuar.

    #pause

    - El uso de dos políticas requiere aplicar #alert[*_importance sampling_*] ordinario o ponderado para que las estimaciones no estén sesgadas.

  ]
]

// *****************************************************************************

#title-slide(
  author: [Antonio Manjavacas Lucas],
  title: "Aprendizaje por refuerzo",
  subtitle: "Métodos basados en muestreo (2)",
  extra: "manjavacas@ugr.es",
)
