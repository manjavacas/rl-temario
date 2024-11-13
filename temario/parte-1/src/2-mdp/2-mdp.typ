#import "@preview/typslides:1.2.0": *

#show: typslides.with(
  ratio: "16-9",
  theme: "greeny",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)

#let colmath(x, color) = text(fill: color)[#x]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: [Procesos de decisión de Markov],
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents()

// *****************************************************************************

#slide(title: "Motivación")[

  #v(1cm)

  Hasta ahora, nos hemos centrado en #stress[problemas no asociativos]:

  - Problemas en los que _no asociamos_ diferentes acciones a diferentes situaciones.

  - El objetivo es encontrar la mejor acción si el problema es #stress[_estacionario_], o buscarla directamente si es #stress[_no-estacionario_].

  No obstante, en problemas de RL más complejos, pueden darse diferentes situaciones donde *el valor de una acción varía dependiendo del estado actual del agente*.

  #v(.5cm)

  #align(center)[
    #framed[Es lo que denominamos un problema de #stress[*búsqueda asociativa*].]
  ]
]

// *****************************************************************************

#title-slide("Búsqueda asociativa")

// *****************************************************************************

#slide(title: "Búsqueda asociativa")[

  #framed(title: "Problema de búsqueda asociativa")[

    - #stress[Búsqueda] basada en prueba y error para encontrar las mejores acciones.

    - #stress[Asociativa], porque trata de asociar a cada situación (estado) la mejor acción disponible.

  ]

  #v(1cm)

  _Elegir la mejor acción para cada estado, a partir de prueba y error_.

]

// *****************************************************************************

#slide(title: [_Contextual bandits_])[

  #v(.8cm)

  #columns(2, gutter: 1cm)[
    A los problemas de búsqueda asociativa también se les denomina #stress[*contextual bandits*] (_bandits_ con contexto).

    - El objetivo es aprender una *política* de comportamiento que mapee cada *situación* con la mejor *acción* posible.

    - Los problemas de búsqueda asociativa/_contextual bandits_ se encuentran a medio camino entre _K-armed bandits_ y los problemas de RL "completos".

    #colbreak()

    #align(center)[#image("images/contextual-bandits.png")]

  ]

]

// *****************************************************************************

#slide(title: [_K-armed bandits_ vs. _Contextual bandits_ vs. RL _completo_])[

  #set text(size: 17pt)
  #table(
    columns: 2,
    inset: 10pt,
    table.header[*Problema*][*Características*],
    [_K-armed bandits_],
    [
      - Elegimos una acción en cada instante de tiempo.
      - Buscamos maximizar la recompensa acumulada a lo largo del tiempo.
      - El valor de las acciones puede ser siempre el mismo (problema estacionario) o variar a lo largo del tiempo (problema no-estacionario).
    ],

    [_Contextual bandits_],
    [
      - Podemos encontrarnos en diferentes situaciones/contextos que harán variar el valor de cada acción.
      - Buscamos aprender a tomar la mejor decisión para cada situación, maximizando las recompensas a largo plazo.
    ],

    [_RL completo_],
    [
      - Buscamos maximizar la recompensa en un ambiente desconocido.
      - Las acciones afectan, no sólo a las recompensas inmediatas, sino también al estado del etnorno, que a su vez repercute en las recompensas futuras.
      - Generalmente entornos estocásticos, no estacionarios y con grandes espacios de estados y acciones.
    ],
  )

]

// *****************************************************************************

#focus-slide("Un ejemplo...")

// *****************************************************************************

#slide(title: [Ejemplo: tienda _online_])[

  #set text(size: 18pt)
  #table(
    columns: 2,
    inset: 10pt,
    table.header[*Problema*][*Características*],
    [_K-armed bandits_],
    [
      - Cada producto a anunciar constituye una acción.
      - En cada instante de tiempo, el agente selecciona el producto a publicitar, y recibe una recompensa positiva si el usuario hace _click_.
    ],

    [_Contextual bandits_],
    [
      - Añadimos contexto: informaicón sobre el usuario, edad, género, historial de búsqueda, etc.
      - Las recompensas también varían dependiendo dle usuario que haga _click_ sobre el anuncio.
    ],

    [_RL completo_],
    [
      - Las acciones ahora pueden repercutir en el entorno y recompensas futuras.
      - Por ejemplo, mostrar un anuncio de forma repetitiva puede molestar al usuario y hacer que abandone el sitio web, evitando que vuelva a hacer _click_ en cualquier otro anuncio.
    ],
  )

]

// *****************************************************************************

#title-slide("Procesos de decisión de Markov")

// *****************************************************************************

#slide(title: "Procesos de decisión de Markov")[

  El marco formal empleado para definir problemas de aprendizaje por refuerzo "completos" es el de #stress[proceso de decisión de Markov] (*MDP*).

  #set text(size: 19pt)

  La interacción *agente-entorno* en un problema de RL puede representarse como un MDP finito de la siguiente manera:

  #v(-.8cm)

  #figure(image("images/mdp-1.png", width: 50%))

]

// *****************************************************************************

#slide(title: "Proceso de decisión de Markov (MDP)")[
  #figure(image("images/mdp-1.png", width: 88%))
]

// *****************************************************************************

#slide(title: "MDP: agente")[
  #figure(image("images/mdp-2.png", width: 84%))
]

// *****************************************************************************

#slide(title: "MDP: entorno")[
  #figure(image("images/mdp-3.png", width: 83%))
]

// *****************************************************************************

#slide(title: "MDP: acción")[
  #figure(image("images/mdp-4.png", width: 90%))
]
// *****************************************************************************

#slide(title: "MDP: estado y recompensa")[
  #figure(image("images/mdp-5.png", width: 90%))
]

// *****************************************************************************

#slide(title: "MDPs parcialmente observables (POMDPs)")[
  #figure(image("images/pomdp.png", width: 90%))
]

// *****************************************************************************

#slide(title: "Definicion formal de MDP")[

  #v(1cm)

  Un proceso de decisión de Markov se define como una 5-tupla: $angle.l cal(S), cal(A), cal(P), cal(R), gamma angle.r$.

  #v(.4cm)

  #framed[
    - $cal(S)$ es el #stress[espacio de estados]. Contiene el conjunto de estados posibles.
    - $cal(A)$ es el #stress[espacio de acciones] (conjunto de posibles acciones). Si las acciones disponibles dependen del estado $s in cal(S)$ actual, el conjunto se define como $cal(A)_s$.
    - $cal(P)$ es una función/matriz de probabilidad de transición entre estados.
    - $cal(R)$ es la función de recompensa que valora las transiciones entre estados.
    - $gamma$ es un factor de descuento. Veremos su utilidad más adelante.
  ]
]

// *****************************************************************************

#slide(title: "Interacción agente-entorno")[

  El agente interactúa con el entorno a lo largo de una secuencia de pasos o #stress[_timesteps_].

  En cada instante de tiempo:

  1. El agente percibe el *estado actual* $S_t$ y realiza una *acción* $A_t$.
  2. El entorno se ve modificado por dicha acción.
  3. El agente percibe el *nuevo estado* del entorno $S_(t+1)$ y recibe una *recompensa* $R_(t+1)$.

  Esta interacción da lugar a una secuencia de estados, acciones y recompensas denominada #stress[trayectoria]:

  #v(.4cm)

  #grayed[
    #set text(size: 24pt)
    $ tau = {S_0, A_0, R_1, S_1, A_1, R_2, dots, #h(0.1cm) S_(T-1), A_(T-1), R_T, S_T} $
  ]

]

// *****************************************************************************

#slide(title: "Probabilidad de transición")[

  En un #stress[MDP finito], los conjuntos $cal(S)$ (estados) y $cal(A)$ (acciones) *son finitos*.

  $R_t$ y $S_t$ son variables aleatorias con distribuciones de probabilidad bien definidas, que solamente dependen del estado anterior $S_(t-1)$ y de la acción realizada $A_t$.

  Para todo $s' in cal(S), r in cal(R)$, existe la probabilidad de que estos valores se den en un instante $t$ dados unos valores particulares para $s in cal(S)$ y $a in cal(A)$:

  #grayed[
    #set text(size: 23pt)
    $ p(s',r|s,a) = PP{S_t = s', R_t = r | S_(t-1) = s, A_(t-1) = a} $
  ]

  #v(.6cm)

  Esta función define las #stress[dinámicas del MDP]:

  #set text(size: 23pt)
  $ p: cal(S) times cal(R) times cal(S) times cal(A) -> [0, 1] $

]

// *****************************************************************************

// *****************************************************************************

#slide(title: "Propiedad de Markov")[

  Se cumple que:

  #v(.5cm)

  #grayed[
    #set text(size: 23pt)
    $ sum_(s' in cal(S), #h(0.1cm) r in cal(R)) p(s', r|s, a) = 1, forall s in cal(S), a in cal(A)(s) $
  ]

  #v(1cm)

  - En un MDP, las probabilidades de transición dependen únicamente del estado y acción inmediatamente previos ($S_(t-1), A_(t-1)$).

  - Es decir, un estado $S_t$ codifica _toda_ la información referente a la interacción agente-entorno previa, y es la *_única_* información necesaria para elegir la acción a realizar.

  Es lo que definimos como #stress[PROPIEDAD DE MARKOV].

]

// *****************************************************************************

#slide()[

  #framed(title: "Propiedad de Markov")[
    El estado actual $S_t$ en un MDP contiene toda la información relevante de los estados pasados $S_(t-1), S_(t-2), dots, S_0$.

    #v(0.5cm)

    Por tanto, la transición a un nuevo estado $S_(t+1)$ no requiere de información sobre los estados previos al estado actual:

    #v(0.5cm)

    $ PP[S_(t+1)|S_t] = Pr[S_(t+1) | S_0, S_1, dots, #h(0.1cm) S_t] $

    #v(0.5cm)

    _El futuro es independiente del pasado, dado el presente._
  ]

]

// *****************************************************************************

#slide(title: "Transición entre estados")[

  La siguiente fórmula representa la #stress[regla de transición] entre estados en un MDP:

  #v(.5cm)

  #grayed[
    #set text(size: 24pt)
    $ p(s'|s,a) = Pr{S_t = s | S_(t-1) = s, A_(t-1) = a} = sum_(r in cal(R)) p(s',r|s,a) $
  ]

  #v(.5cm)

  Proporciona la probabilidad de transicionar a $s'$ partiendo de $s$ y ejecutando $a$.

]

// *****************************************************************************

#slide(title: "Transición entre estados")[

  #align(center)[
    #framed[
      _¿Por qué necesitamos saber las probabilidades de transición?_
    ]
  ]

  #v(.8cm)

  En problemas de RL #stress[deterministas], una acción $a$ desde un estado $s$ siempre conduce al mismo estado $s'$.
  - _Ej. ajedrez_ $-->$ reglas fijas.

  Pero en problemas de RL #stress[estocásticos], la misma acción $a$ puede llevar a diferentes estados $s'$.
  - _Ej. controlar la trayectoria de un dron_ $-->$ viento.

]

// *****************************************************************************

#focus-slide("Un ejemplo...")

// *****************************************************************************

#slide(title: "Ejemplo")[
  #figure[
    #image("images/mdp-example-2.png", width: 90%)
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #columns(2)[

    #figure[#image("images/mdp-example-2.png", width: 100%)]
    #columns(2, gutter: 10pt)[
      #grayed[
        $cal(S) = {s_0, s_1}$

        $s_0 :$ #text(size: 15pt)[en movimiento]\
        $s_1 :$ #text(size: 17pt)[quieto]
      ]

      #colbreak()

      #grayed[
        $cal(A) = {a_0, a_1}$

        $a_0 :$ #text(size: 17pt)[avanzar]\
        $a_1 :$ #text(size: 17pt)[detener]
      ]
    ]

    #colbreak()

    #v(0.5cm)

    $ p(s_1, 0 | s_0, a_1) = $

    $ p(s_0| s_0, a_0) = $

    $ p(s_1| s_0, a_0) = $

    $ p(s_1, 1 | s_1, a_0) = $

    $ p(s_0, 1 | s_1, a_1) = $

    #v(.5cm)


  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #columns(2)[

    #figure[#image("images/mdp-example-2.png", width: 100%)]
    #columns(2, gutter: 10pt)[
      #grayed[
        $cal(S) = {s_0, s_1}$

        $s_0 :$ #text(size: 15pt)[en movimiento]\
        $s_1 :$ #text(size: 17pt)[quieto]
      ]

      #colbreak()

      #grayed[
        $cal(A) = {a_0, a_1}$

        $a_0 :$ #text(size: 17pt)[avanzar]\
        $a_1 :$ #text(size: 17pt)[detener]
      ]
    ]

    #colbreak()

    #v(0.5cm)

    $ p(s_1, 0 | s_0, a_1) = bold(1) $

    $ p(s_0| s_0, a_0) = bold(0.9) $

    $ p(s_1| s_0, a_0) = bold(0.1) $

    $ p(s_1, 1 | s_1, a_0) = bold(0) $

    $ p(s_0, 1 | s_1, a_1) = bold(0) $

    #v(.5cm)

    #stress[Propiedad de Markov]: las transiciones sólo dependen del *estado actual* (y la *acción* realizada).

  ]

]

// *****************************************************************************

#slide(title: "Recompensa esperada")[

  #v(1.3cm)

  ¿Qué *recompensa* podemos esperar de un par #stress[acción-estado]?

  #grayed[
    #set text(size: 24pt)
    $ r(s,a) = EE[R_t | S_(t+1) = s, A_(t-1) = a] = sum_(r in cal(R)) r sum_(s' in cal(S)) p(s', r | s,a) $
  ]

  #v(1cm)

  ¿Qué *recompensa* podemos esperar de una tripleta #stress[estado-acción-estado]?

  #grayed[
    #set text(size: 24pt)
    $r(s,a,s') = EE[R_t | S_(t-1) = s, A_(t-1) = a, S_(t) = s'] = sum_(r in cal(R)) r p(s',r|s,a) / p(s'|s,a)$
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #columns(2)[

    #figure[#image("images/mdp-example-2.png", width: 100%)]
    #columns(2, gutter: 10pt)[
      #grayed[
        $cal(S) = {s_0, s_1}$

        $s_0 :$ #text(size: 15pt)[en movimiento]\
        $s_1 :$ #text(size: 17pt)[quieto]
      ]

      #colbreak()

      #grayed[
        $cal(A) = {a_0, a_1}$

        $a_0 :$ #text(size: 17pt)[avanzar]\
        $a_1 :$ #text(size: 17pt)[detener]
      ]
    ]

    #colbreak()

    #v(0.5cm)

    $ r(s_0, a_1) = $

    $ r(s_1, a_0) = $

    $ r(s_0, a_0) = $

    $ r(s_0, a_0, s_0) = $

    $ r(s_1, a_1, s_0) = $

    #v(.2cm)

  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #columns(2)[

    #figure[#image("images/mdp-example-2.png", width: 100%)]
    #columns(2, gutter: 10pt)[
      #grayed[
        $cal(S) = {s_0, s_1}$

        $s_0 :$ #text(size: 15pt)[en movimiento]\
        $s_1 :$ #text(size: 17pt)[quieto]
      ]

      #colbreak()

      #grayed[
        $cal(A) = {a_0, a_1}$

        $a_0 :$ #text(size: 17pt)[avanzar]\
        $a_1 :$ #text(size: 17pt)[detener]
      ]
    ]

    #colbreak()

    #v(0.5cm)

    $ r(s_0, a_1) = bold(0) $

    $ r(s_1, a_0) = bold(1) $

    $ r(s_0, a_0) = (1 dot 0.9) + (0 dot 0.1) = bold(0.9) $

    $ r(s_0, a_0, s_0) = bold(1) $

    $ r(s_1, a_1, s_0) = #h(.2cm) "?" $

    #v(.2cm)

    #grayed[
      #set text(size: 21pt)
      $ r(s, a, s') = sum_(r in cal(R)) r p(s',r|s,a) / colmath(cancel(p(s'|s,a)), #red) $
    ]

  ]

]

// *****************************************************************************

#focus-slide("Algunas consideraciones...")