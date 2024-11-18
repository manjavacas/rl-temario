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
  subtitle: "Procesos de decisión de Markov",
  extra: "manjavacas@ugr.es",
)

// *****************************************************************************

#slide(title: "Índice")[
  #metropolis-outline
]

// *****************************************************************************

#slide(title: "Motivación")[

  Hasta ahora, nos hemos centrado en #alert[*problemas no asociativos*]:

  - Problemas en los que _no asociamos_ diferentes acciones a diferentes situaciones.

  - El objetivo es encontrar la mejor acción si el problema es #alert[_estacionario_], o buscarla directamente si es #alert[_no-estacionario_].

  No obstante, en problemas de RL más complejos, pueden darse diferentes situaciones donde *el valor de una acción varía dependiendo del estado actual del agente*.

  #shadow[Es lo que denominamos un problema de #alert[*búsqueda asociativa*].]

]

// *****************************************************************************

#new-section-slide("Búsqueda asociativa")

// *****************************************************************************

#slide(title: "Búsqueda asociativa")[

  #frame(title: "Problema de búsqueda asociativa")[

    #v(0.3cm)

    - #alert[*Búsqueda*] basada en prueba y error para encontrar las mejores acciones.

    #v(0.3cm)

    - #alert[*Asociativa*], porque trata de asociar a cada situación (estado) la mejor acción disponible.

  ]

  #pause

  #v(1cm)

  _Elegir la mejor acción para cada estado, a partir de prueba y error_.

]

// *****************************************************************************

#let c = text[_Contextual bandits_]

#slide(title: [#c])[

  #box[
    #columns(2, gutter: 30pt)[
      A los problemas de búsqueda asociativa también se les denomina #alert[_*contextual bandits*_] (_bandits_ con contexto).

      - El objetivo es aprender una *política* de comportamiento que mapee cada *situación* con la mejor *acción* posible.

      - Los problemas de búsqueda asociativa / _contextual bandits_ se encuentran a medio camino entre _K-armed bandits_ y los problemas de RL completos.

      #colbreak()

      #align(center)[#image("images/contextual-bandits.png")]

    ]
  ]

]

// *****************************************************************************

#let k = text[_K-armed bandits_ vs. _Contextual bandits_ vs. RL completo]

#slide(title: [#k])[

  #box(height: 500pt)[
    #set text(size: 18pt)
    #table(
      columns: 2,
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

      [RL completo],
      [
        - Buscamos maximizar la recompensa en un ambiente desconocido.
        - Las acciones afectan, no sólo a las recompensas inmediatas, sino también al estado del etnorno, que a su vez repercute en las recompensas futuras.
        - Generalmente entornos estocásticos, no estacionarios y con grandes espacios de estados y acciones.
      ],
    )
  ]

]


// *****************************************************************************

#let k = text[Ejemplo: tienda _online_]

#slide(title: [#k])[

  #box(height: 500pt)[
    #set text(size: 18pt)
    #table(
      columns: 2,
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

      [RL completo],
      [
        - Las acciones ahora pueden repercutir en el entorno y recompensas futuras.
        - Por ejemplo, mostrar un anuncio de forma repetitiva puede molestar al usuario y hacer que abandone el sitio web, evitando que vuelva a hacer _click_ en cualquier otro anuncio.
      ],
    )
  ]

]

// *****************************************************************************

#new-section-slide("Procesos de decisión de Markov")

// *****************************************************************************

#slide(title: "Procesos de decisión de Markov")[

  #box(height: 300pt)[
    El marco formal empleado para definir problemas de aprendizaje por refuerzo es el de #alert[*proceso de decisión de Markov*] (*MDP*).

    La interacción *agente-entorno* en un problema de RL puede representarse como un MDP finito de la siguiente manera:

    #align(center)[#image("images/mdp-1.png", width: 50%)]

    #v(0.2cm)
  ]
]

// *****************************************************************************

#slide(title: "Proceso de decisión de Markov (MDP)")[
  #align(center)[
    #box(height: 400pt)[
      #image("images/mdp-1.png", width: 90%)
    ]
  ]
]

// *****************************************************************************

#slide(title: "MDP: agente")[
  #align(center)[
    #box(height: 400pt)[
      #image("images/mdp-2.png", width: 80%)
    ]
  ]
]

// *****************************************************************************

#slide(title: "MDP: entorno")[
  #align(center)[
    #box(height: 400pt)[
      #image("images/mdp-3.png", width: 79%)
    ]
  ]
]

// *****************************************************************************

#slide(title: "MDP: acción")[
  #align(center)[
    #box(height: 400pt)[
      #image("images/mdp-4.png", width: 100%)
    ]
  ]
]
// *****************************************************************************

#slide(title: "MDP: estado y recompensa")[
  #align(center)[
    #box(height: 400pt)[
      #image("images/mdp-5.png", width: 100%)
    ]
  ]
]

// *****************************************************************************

#slide(title: "MDPs parcialmente observables (POMDPs)")[
  #align(center)[
    #box(height: 400pt)[
      #image("images/pomdp.png", width: 96%)
    ]
  ]
]

// *****************************************************************************

#slide(title: "Interacción agente-entorno")[

  El agente interactúa con el entorno a lo largo de una secuencia de pasos o #alert[_timesteps_].

  En cada instante de tiempo:

  1. El agente percibe el *estado actual* $S_t$ y realiza una *acción* $A_t$.
  2. El entorno se ve modificado por dicha acción.
  3. El agente percibe el *nuevo estado* del entorno $S_(t+1)$ y recibe una *recompensa* $R_(t+1)$.

  Esta interacción da lugar a una secuencia de estados, acciones y recompensas denominada #alert[*trayectoria*]:

  #align(center)[
    #shadow[
      $ tau = {S_0, A_0, R_1, S_1, A_1, R_2, dots, #h(0.1cm) S_(T-1), A_(T-1), R_T, S_T} $
    ]
  ]

]

// *****************************************************************************

#slide(title: "Probabilidad de transición")[

  #box(height: 400pt)[
    En un #alert[MDP finito], los conjuntos $cal(S)$ (estados), $cal(A)$ (acciones) y $cal(R)$ (recompensas) *son finitos*.

    $R_t$ y $S_t$ son variables aleatorias con distribuciones de probabilidad bien definidas, que solamente dependen del estado anterior $S_(t-1)$ y de la acción realizada $A_t$.

    Es decir, para todo $s' in cal(S), r in cal(R)$, existe la probabilidad de que estos valores se den en un instante $t$ dados unos valores particulares para $s in cal(S)$ y $a in cal(A)$:

    #align(center)[
      #shadow[
        $ p(s',r|s,a ) = Pr{S_t = s', R_T = r | S_(t-1) = s, A_(t-1) = a} $
      ]
    ]

    Esta función define las #alert[dinámicas del MDP]:

    $ p: cal(S) times cal(R) times cal(S) times cal(A) -> [0, 1] $
  ]

]

// *****************************************************************************

#slide(title: "Propiedad de Markov")[

  #box(height: 400pt)[
    Se cumple que:
    #align(center)[
      #shadow[
        $ sum_(s' in cal(S), #h(0.1cm) r in cal(R)) p(s', r|s, a) = 1, forall s in cal(S), a in cal(A)(s) $
      ]
    ]

    - En un MDP, las probabilidades de transición dependen únicamente del estado y acción inmediatamente previos ($S_(t-1), A_(t-1)$).

    - Es decir, un estado $S_t$ codifica _toda_ la información referente a la interacción agente-entorno previa, y es la _única_ información necesaria para elegir la acción a realizar.

    Es lo que definimos como #alert[*PROPIEDAD DE MARKOV*].
  ]

]

// *****************************************************************************

#slide(title: "Propiedad de Markov")[

  #frame(title: "Propiedad de Markov")[
    El estado actual $S_t$ en un MDP contiene toda la información relevante de los estados pasados $S_(t-1), S_(t-2), dots, S_0$.

    #v(0.5cm)

    Por tanto, la transición a un nuevo estado $S_(t+1)$ no requiere de información sobre los estados previos al estado actual:

    #v(0.5cm)

    $ Pr[S_(t+1)|S_t] = Pr[S_(t+1) | S_0, S_1, dots, #h(0.1cm) S_t] $

    #v(0.5cm)

    _El futuro es independiente del pasado, dado el presente._
  ]

]

// *****************************************************************************

// #slide(title: "Ejemplo 1")[

//   #box(height: 200pt)[
//     #columns(2, gutter:30pt)[
//       #image("images/mdp-example-1.png", width:110%)

//       #colbreak()

//       $ P_(ss') = mat(0.9, 0.1; 0.5, 0.5) $

//       #align(center)[
//         #table(
//           columns: 3,
//             [], [*Soleado*], [*Lluvioso*],
//             [*Soleado*], [0.9], [0.1],
//             [*Lluvioso*], [0.5], [0.5]
//         )
//       ]
//     ]
//   ]

// ]

// *****************************************************************************

#slide(title: "Transición entre estados")[

  La siguiente fórmula representa la #alert[regla de transición] entre estados en un MDP:

  #align(center)[
    #shadow[
      $ p(s'|s,a) = Pr{S_t = s | S_(t-1) = s, A_(t-1) = a} = sum_(r in cal(R)) p(s',r|s,a) $
    ]
  ]

  Proporciona la probabilidad de transicionar a $s'$ partiendo de $s$ y ejecutando $a$.

]

// *****************************************************************************

#slide(title: "Transición entre estados")[

  #shadow[
    _¿Por qué necesitamos saber las probabilidades de transición?_
  ]

  En problemas de RL #alert[*deterministas*], una acción $a$ desde un estado $s$ siempre conduce al mismo estado $s'$.
  - _Ej. ajedrez_ $-->$ reglas fijas.

  Pero en problemas de RL #alert[*estocásticos*], la misma acción $a$ puede llevar a diferentes estados $s'$.
  - _Ej. controlar la trayectoria de un dron_ $-->$ viento.

  #align(right)[
    #shadow[
      _Veamos un ejemplo..._
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/mdp-example-2.png", width: 75%)
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height: 400pt)[
    #columns(2)[

      #image("images/mdp-example-2.png", width: 110%)
      #columns(2, gutter: 10pt)[
        #text(size: 15pt)[
          #shadow[
            $cal(S) = {s_0, s_1}$

            - $s_0 : $ en movimiento
            - $s_1 : $ quieto
          ]

          #colbreak()

          #shadow[
            $cal(A) = {a_0, a_1}$

            - $a_0 : $ avanzar
            - $a_1 : $ detener
          ]
        ]
      ]

      #colbreak()

      #v(0.5cm)

      $ p(s_1, 0 | s_0, a_1) = #uncover(range(2,7))[1] $

      #pause

      $ p(s_0| s_0, a_0) = #uncover(range(3,7))[0.9] $

      #pause

      $ p(s_1| s_0, a_0) = #uncover(range(4,7))[0.1] $

      #pause

      $ p(s_1, 1 | s_1, a_0) = #uncover(range(5,7))[0] $

      #pause

      $ p(s_0, 1 | s_1, a_1) = #uncover(range(6,7))[0] $

      #pause

      #alert[Propiedad de Markov]: las transiciones sólo dependen del *estado actual* (y la *acción* realizada).

    ]
  ]

]

// *****************************************************************************

#slide(title: "Recompensa esperada")[

  ¿Qué *recompensa* podemos esperar de un par #alert[acción-estado]?

  #align(center)[
    #shadow[
      $ r(s,a ) = EE[R_t | S_(t+1) = s, A_(t-1) = a] = sum_(r in cal(R)) r sum_(s' in cal(S)) p(s', r | s,a) $
    ]
  ]

  ¿Qué *recompensa* podemos esperar de una tripleta #alert[estado-acción-estado]?

  #align(center)[
    #shadow[
      $r(s,a,s') = EE[R_t | S_(t-1) = s, A_(t-1) = a, S_(t) = s'] = sum_(r in cal(R)) r p(s',r|s,a) / p(s'|s,a)$
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height: 400pt)[
    #columns(2)[

      #image("images/mdp-example-2.png")
      #columns(2, gutter: 10pt)[
        #text(size: 15pt)[
          #shadow[
            $cal(S) = {s_0, s_1}$

            - $s_0 : $ en movimiento
            - $s_1 : $ quieto
          ]

          #colbreak()

          #shadow[
            $cal(A) = {a_0, a_1}$

            - $a_0 : $ avanzar
            - $a_1 : $ detener
          ]
        ]
      ]

      #colbreak()

      #v(0.5cm)

      $ r(s_0, a_1) = #uncover(range(2,7))[0] $

      #pause

      $ r(s_1, a_0) = #uncover(range(3,7))[1] $

      #pause

      $ r(s_0, a_0) = #uncover(range(4,7))[$(1 dot 0.9) + (0 dot 0.1) = 0.9$] $

      #pause

      $ r(s_0, a_0, s_0) = #uncover(range(5,7))[1] $

      #pause

      $ r(s_1, a_1, s_0) = #uncover(range(6,7))[#text(fill:red)[?]] $

      #pause

      #align(center)[
        #shadow[
          #text(size: 17pt)[
            $ r(s, a, s') = sum_(r in cal(R)) r p(s',r|s,a) / colmath(cancel(p(s'|s,a)), #red) $
          ]
        ]
      ]

    ]
  ]

]

// *****************************************************************************

#focus-slide("Algunas consideraciones...")

// *****************************************************************************

#slide(title: "Frontera agente-entorno")[

  #box(height: 400pt)[
    #columns(2, gutter: 40pt)[

      #v(3cm)

      Consideramos *entorno* a todo aquello sobre lo que el agente no tiene control.

      #shadow[
        Es decir, la #alert[frontera agente-entorno] viene dada por las capacidades de control del agente, no por su conocimiento.
      ]

      #colbreak()

      #align(center)[
        #v(0.5cm)
        #image("images/tetris-rl.png", width: 120%)
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Interacción agente-entorno")[

  #box(height: 400pt)[
    #columns(2, gutter: 40pt)[

      #v(1cm)

      Podemos resumir el *aprendizaje basado en interacción* en 3 señales:

      1. #alert[Acciones]: elecciones, control del agente.
      2. #alert[Estados]: información en base a dichas elecciones.
      3. #alert[Recompensas]: adecuación al objetivo.

      El nivel de abstracción / complejidad de estados y acciones dependerá del problema a tratar.

      #colbreak()

      #align(center)[
        #v(0.5cm)
        #image("images/tetris.png", width: 60%)
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Representaciones estructuradas")[

  #box(height: 400pt)[
    #columns(2, gutter: 30pt)[

      Es común contar con *representaciones estructuradas* de estados y acciones (ej. vectores de valores).

      #align(center)[
        #shadow[
          $ S_t : {M_t, op("type"), op("pos"), op("next"), op("score")} $
        ]
      ]

      #text(size: 15pt)[
        - $M_t$ : matriz con posiciones libres (0) u ocupadas (1)
        - _type_: pieza actual
        - _pos_: posición de la pieza actual
        - _next_: próxima pieza
        - _score_: puntuación acumulada
      ]

      #align(center)[
        #shadow[
          $ cal(A) : {0: \u{2B05}, 1 : \u{27A1}, 2 : \u{2B07}, 3: \u{2B06}} $
          $ A_t in {0,1,2,3} $
        ]
      ]

      #colbreak()

      #align(center)[
        #v(0.5cm)
        #image("images/tetris.png", width: 60%)
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Estados no-markovianos")[

  En un proceso de decisión de Markov, el futuro depende únicamente del estado presente y no de los estados anteriores (*propiedad de Markov*).

  Sin embargo, podemos encontrarnos ante problemas con #alert[*estados no-markovianos*], donde el estado actual no contiene toda la información relevante para predecir el futuro.

  #v(1cm)

  #frame(title: "Estado no-markoviano")[
    Un estado no-markoviano es aquel en el que la información necesaria para tomar una decisión óptima no está completamente representada por el estado actual del sistema.
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[
    #box(height: 500pt)[

      #shadow[_¿La bola va hacia la niña o hacia el hombre?_]

      #colbreak()

      #v(0.5cm)
      #image("images/markov-example.jpeg")
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height: 500pt)[
    #columns(2, gutter: 30pt)[

      - En este ejemplo, no podemos predecir el movimiento de la bola a partir de una sola imagen.
        - Una imagen instantánea no nos ofrece la suficiente información.

        - #alert[Estado no-markoviano].

      - Una posible solución sería *concatenar múltiples fotogramas consecutivos*.

      #align(center)[
        #v(0.5cm)
        #image("images/markov-example.jpeg")
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Temporalidad")[

  #shadow[
    Los *_time steps_* pueden no darse en intervalos de tiempo fijos, sino estar #alert[condicionados por eventos].
  ]

  #columns(2, gutter: 20pt)[
    Por ejemplo:

    - Movimiento de piezas en una partida de ajedrez.
    - Cambio de valor en el precio de un acción.
    - Acceso a la web de venta de un producto.
    - ...

    #colbreak()

    #align(center)[
      #image("images/move.png", width: 60%)
    ]
  ]

]

// *****************************************************************************

#new-section-slide("Problemas episódicos y continuados")

// *****************************************************************************

#slide(title: "Problemas episódicos")[

  #box(height: 400pt)[
    #columns(2, gutter: 30pt)[

      El #alert[*estado inicial*] de un problema de RL es el estado en el cual comienza la interacción del agente con el entorno.

      Alcanzar un #alert[*estado terminal*] supone el fin de esta interacción.

      Un problema de RL puede contar con múltiples estados iniciales y finales.

      #shadow[
        #text(size: 18.5pt)[
          - Estados no terminales: $cal(S)$.
          - Estados terminales y no terminales: $cal(S^+)$.
        ]
      ]

      Definimos así el concepto de #alert[*episodio*].

      #colbreak()

      #frame(title: "Episodio")[
        Secuencia de _time steps_ desde un estado inicial hasta un estado terminal.
      ]

      #align(center)[
        #image("images/episode.png")
      ]

      La longitud $T$ de un episodio no tiene por qué ser fija, y puede variar entre episodios.
    ]
  ]
]

// *****************************************************************************

#slide(title: "Problemas episódicos")[

  #frame(title: "Problema episódico")[
    Problema dividido en una secuencia *finita* de estados, desde un estado inicial hasta un estado terminal.
  ]

]

// *****************************************************************************

#focus-slide[¿Y si el problema no tiene fin?]

// *****************************************************************************

#slide(title: "Problemas continuados")[

  En los #alert[*problemas continuados*] (_vs._ episódicos), no existen episodios que finalicen en un estado terminal.

  - Es decir, *no hay estados terminales*.

  - Por tanto, el problema no finaliza en un _time step_ $T$ concreto ($T=infinity$).

  #v(0.2cm)

  #frame(title: "Problema continuado")[
    Problema consistente en una secuencia *infinita* de estados, partiendo de un estado inicial.
  ]

  #v(0.2cm)

  Suelen ser problemas más cercanos a la realidad (control térmico, robótica, ...).

]

// *****************************************************************************

#new-section-slide("Objetivos y recompensas")

// *****************************************************************************

#slide(title: "Objetivos y recompensas")[

  _¿Qué relación hay entre las #alert[señales de recompensa] y los #alert[objetivos] del agente?_

  #pause

  _¿Cómo se realiza el #alert[cálculo] de las recompensas?_

  #pause

  _¿Cómo condicionamos el #alert[comportamiento] del agente en base a dichas recompensas?_

]

// *****************************************************************************

#slide(title: "Recompensa")[

  #box(height: 400pt)[
    #columns(2, gutter: 30pt)[

      Para guiar a un agente hacia su *objetivo*, empleamos *recompensas*.

      Una señal de #alert[*recompensa*] es un valor numérico que indica al agente si su comportamiento le acerca o no a su objetivo.

      #text(size: 24pt)[
        $ R_t in RR $
      ]

      Buscamos maximizar la #alert[recompensa acumulada] a largo plazo, no sólo las #alert[recompensas inmediatas].

      #colbreak()

      #image("images/skinner.png", width: 100%)

    ]
  ]

]

// *****************************************************************************

#let hp = text[_Reward hypotheses_]

#slide(title: [#hp])[

  #shadow[
    _Todo lo que entendemos como objetivo o propósito puede interpretarse como la maximización del valor esperado para una suma acumulada de una señal escalar (llamada recompensa)_.

    #align(right)[
      #text(size: 12pt)[
        #emoji.books _Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction (2nd ed.). MIT press. (p. 53)._]
    ]
  ]

  El uso de una señal de recompensa para formalizar la idea de *objetivo* es uno de los aspectos más distintivos del aprendizaje por refuerzo.

]

// *****************************************************************************

#slide(title: "Función de recompensa")[

  #box(height: 500pt)[
    Las recompensas que el agente recibe vienen dadas por una #alert[función de recompensa], que generalmente depende del *estado* alcanzado, o de la *acción* realizada, esto es: $r_t = R(S_t)$, o bien: $r_t = R(S_t, A_t)$.

    #v(0.5cm)

    #columns(2)[
      #align(center)[#image("images/reward-example.png", width: 120%)]
      #colbreak()
      #align(center)[#image("images/reward-example-2.png", width: 100%)]
    ]
  ]
]

// *****************************************************************************

#slide(title: "Objetivos y subobjetivos")[
  #shadow[
    El #alert[objetivo] de un agente de RL es #alert[*maximizar la recompensa acumulada*] (_return_) a lo largo del tiempo.
  ]

  #box(height: 150pt)[
    #text(size: 19pt)[
      #columns(2, gutter: 0%)[

        #align(center)[
          #image("images/chess.png", width: 40%)
        ]

        #colbreak()

        - *Agente orientado a subobjetivos*: cada vez que se come una pieza, $R = +1$ (o valor variable, dependiendo de la pieza comida).

        - *Agente orientado a objetivos*: si se gana, $R = +1$, si se pierde: $R = -1$, si se empata (_tablas_): $R = 0$.
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Objetivos y subobjetivos")[

  #box(height: 200pt)[
    #text(size: 19pt)[
      #columns(2, gutter: 0%)[


        #align(center)[
          #image("images/chess.png", width: 40%)
        ]

        #colbreak()

        La recompensa *no* debe orientarse exclusivamente hacia el cumplimiento de *subobjetivos*, sino hacia el cumplimiento de un *objetivo final*.

        - Ej. _comer piezas sin ningún criterio_.

      ]
    ]
  ]

  Si, por ejemplo, queremos fomentar cierto comportamiento desde un principio, es mejor emplear otros recursos, como valores iniciales optimistas.

]

// *****************************************************************************

#slide(title: "Retorno")[

  El #alert[*retorno*], o *_recompensa acumulada_*, es el valor que tratamos de maximizar.

  Se define de la siguiente manera:

  #text(size: 25pt)[
    #align(center)[
      #shadow[
        $ G_t = R_(t+1) + R_(t+2) + dots + R_(T-1) + R_T $
      ]
    ]
  ]

  Siendo $T$ el último _time step_ del *episodio* (o de una ventana de tiempo determinada).

  #frame(title: "Retorno")[
    Suma de las recompensas a obtener desde el momento presente hasta el final de un episodio o ventana de tiempo determinada.
  ]

]

// *****************************************************************************

#slide(title: "Retorno")[

  #text(size: 25pt)[
    #align(center)[
      #shadow[
        $ G_t = R_(t+1) + R_(t+2) + dots + R_(T-1) + R_T $
      ]
    ]
  ]

  Esta formulación es válida para *problemas episódicos*, pero...

  #pause

  #text(fill: red)[¿Qué ocurre en los *problemas continuados*?]

  - Si el _time step_ final es $T = infinity$, la recompensa esperada es una suma infinita $G_t = infinity$.

  #shadow[Necesitamos reformular la definición de recompensa acumulada.]
]

// *****************************************************************************

#slide(title: "Retorno descontado")[

  Introducimos el concepto de #alert[*retorno descontado*]:

  #text(size: 25pt)[
    #align(center)[
      #shadow[
        $ G_t = R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + dots = sum_(k=0)^infinity gamma^k R_(t+k+1) $
      ]
    ]
  ]

  Donde $gamma in [0,1]$ se denomina #alert[*factor de descuento*] (_discount factor_).

]

// *****************************************************************************

#slide(title: "Factor de descuento")[

  #align(center)[
    #shadow[
      $ G_t = R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + dots = sum_(k=0)^infinity gamma^k R_(t+k+1) $
    ]
  ]

  - El factor de descuento determina el #alert[valor presente asignado a recompensas futuras].

  - Una recompensa recibida en $k$ _time steps_ futuros tiene un valor $gamma^(k-1)$ veces lo que valdría en el _time step_ actual.

  - Si $gamma = 0$, el agente solamente tendrá en cuenta las #alert[recompensas inmediatas]. Se trata de un _agente miope_, que sólo tiene en cuenta $R_(t+1)$ para elegir $A_t$.

  - A medida que $gamma$ se aproxima a $1$, el agente tendrá más en cuenta aquellas acciones que maximicen las #alert[recompensas futuras].

]

// *****************************************************************************

#slide(title: "Definición recursiva")[

  #let r = text[Recompensa\ inmediata]
  #let g = text[_Return_\ descontado\ desde $t+1$]

  El retorno descontado puede definirse #alert[*de forma recursiva*]:

  #v(0.8cm)

  #align(center)[
    #alternatives-match((
      "1": [
        $
          G_t &= R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + dots \
          &= R_(t+1) + gamma (R_(t+2) + gamma R_(t+3) + dots) \
          &= R_(t+1) + gamma G_(t+1)
        $
        #v(2cm)
      ],
      "2": [
        $
          G_t &= R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + gamma^3 R_(t+4) + dots \
          &= R_(t+1) + gamma (R_(t+2) + gamma R_(t+3) + gamma^2 R_(t+4) + dots) \
          &= colmath(underbracket(R_(t+1), #r), #red) + colmath(underbracket(gamma G_(t+1), #g), #blue)
        $
      ],
      "3": [
        #text(size: 25pt)[
          $ G_t = R_(t+1) + gamma G_(t+1) $
        ]
        #align(center)[
          #v(1cm)
          #shadow[
            Esta formulación será importante para la teoría\ y algoritmos de RL que veremos más adelante.
          ]
        ]
      ],
    ))
  ]
]

// *****************************************************************************

#slide(title: "Recompensa constante")[

  #text(size: 25pt)[
    $ G_t = R_(t+1) + gamma G_(t+1) $
  ]

  La definición recursiva de $G_t$ es válida para todo _time step_ $t < T$, incluso si la terminación ocurre en $t + 1$, siempre que definamos $G_T = 0$.

  Por otro lado, aunque $G_t$ sea una suma infinita, se convierte en finita si la recompensa es siempre $> 0 $ y constante (con $gamma < 1$).

  - Por ejemplo, si la recompensa es siempre $+1$, el retorno será:

  $ G_t = sum_(k=0)^infinity gamma^k = 1 / (1-gamma) $

]

// *****************************************************************************

#slide(title: "¿Cómo definir la recompensa?")[

  #text(size: 19pt)[
    Existen diferentes formas de guiar el aprendizaje mediante una funciones de recompensa.

    El aprendizaje puede basarse en #alert[refuerzos positivos] o #alert[negativos]. Por ejemplo:

    #box(height: 150pt)[

      #columns(2, gutter: 0%)[

        #shadow[
          Recompensa basada en *objetivos*:

          $+1$ si el agente alcanza un objetivo \
          $+0$ en cualquier otro caso
        ]

        #colbreak()

        #shadow[
          Recompensa basada en *penalizaciones*:

          $-1$ por _time step_ empleado \
          $+0$ cuando se alcanza el objetivo.
        ]

      ]
    ]
  ]

  Cualquier representación de la función de recompensa tiene sus _pros_ y sus _contras_, por lo que la elección de una u otra dependerá del problema que tratemos de abordar.

]

// *****************************************************************************

#slide(title: "¿Cómo definir la recompensa?")[

  - ¿Qué definición de recompensa emplearías para entrenar a un robot a salir de un laberinto?

  #pause

  - ¿Y para conducir un coche autónomo?

]

// *****************************************************************************

#let i = text[_Inverse reinforcement learning_]

#slide(title: [#i])[

  Existen formas alternativas de aplicar las funciones de recompensa.

  Por ejemplo, el #alert[_inverse reinforcement learning_] (RL inverso) consiste en plantear un ejemplo de comportamiento óptimo y hacer que el agente adivine la recompensa a maximizar que se asocia con este.

  #v(0.5cm)

  #align(center)[
    #shadow[
      *Comportamiento* $->$ *Recompensa* \ _vs._\ *Recompensa* $->$ *Comportamiento*
    ]
  ]

]


// *****************************************************************************

#slide(title: "En resumen...")[

  Un *MDP* se define por la tupla:

  #text(size: 25pt)[
    $ angle.l cal(S), cal(A), cal(P), cal(R), gamma angle.r $
  ]

  #emoji.checkmark.box Un conjunto de #alert[estados] $cal(S)$.

  #emoji.checkmark.box Un conjunto de #alert[acciones] $cal(A)$.

  #emoji.checkmark.box Una #alert[función de transición] $cal(P)$.

  #emoji.checkmark.box Una función de #alert[recompensa] $cal(R) : cal(S) times cal(A) times cal(S) -> RR $

  #emoji.checkmark.box Un #alert[factor de descuento] $gamma in [0, 1]$.

]


// *****************************************************************************

#new-section-slide("Políticas")

// *****************************************************************************

#slide(title: "Política")[

  Una #alert[*política*] es una función que refleja la probabilidad de emplear una determinada acción $a in cal(A)(s)$ a partir de un estado $s in cal(S)$.

  - La política rige el comportamiento del agente, representando su preferencia por unas acciones u otras ante diferentes estados.

  #align(center)[#image("images/policy.png", width: 50%)]

  Diferenciamos entre políticas #alert[*deterministas*] y #alert[*estocásticas*].

]

// *****************************************************************************

#slide(title: "Tipos de políticas")[


  #box(height: 400pt)[

    #columns(2, gutter: 40pt)[

      #frame(title: "Política determinista")[
        La probabilidad de tomar una acción es 0 ó 1:
        $ a_t = mu(s_t) $
      ]

      #frame(title: "Política estocástica")[
        Distribución de probabilidades de todas las acciones posibles:
        $ a_t tilde.op pi(dot|s_t) $
      ]

      #colbreak()

      #v(3cm)

      #align(center)[
        En ambos casos se cumple que:
        #text(size: 24pt)[
          #shadow[
            $ sum_(a in cal(A)(s)) pi(s|a) = 1 $
          ]
        ]


      ]
    ]
    #pause

    #text(size: 17pt)[
      #text(fill: blue)[Por simplicidad, emplearemos indistintamente $bold(pi)$ para ambos tipos de políticas.]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Tipos de políticas")[

  #frame(title: "Política determinista")[
    La probabilidad de tomar una acción es 0 ó 1:
    $ pi(a | s) in {0, 1} $
  ]

  #v(1cm)

  #align(center)[#image("images/deterministic.png")]

]

// *****************************************************************************

#slide(title: "Tipos de políticas")[

  #frame(title: "Política estocástica")[
    Distribución de probabilidades de todas las acciones posibles:
    $ pi(a | s) in [0, 1] $
  ]

  #v(1cm)

  #align(center)[#image("images/stochastic.png")]

]

// *****************************************************************************

#slide(title: "Políticas estocásticas")[

  #box(height: 400pt)[
    #columns(2, gutter: 40pt)[

      #v(1cm)

      #frame(title: "Política categórica")[
        Selecciona acciones de una #alert[distribución categórica].
        - Se emplea en *espacios de acciones discretos*.
      ]

      #frame(title: "Política gaussiana")[
        Muestrea acciones de una #alert[distribucción gaussiana].
        - Se emplea en *espacios de acciones continuos*.
      ]

      #colbreak()

      #align(center)[#image("images/categorical.png", width: 65%)]

      #align(center)[#image("images/gaussian.png")]

    ]
  ]

]

// *****************************************************************************

#slide(title: "Pregunta...")[

  #align(center)[

    _¿Alternar entre acciones (ej. $a_0, a_1, a_2, a_0, a_1, a_2, dots$) sería una *política* válida?_

    #pause

    #v(0.5cm)

    #shadow[
      #emoji.warning *NO*, porque se incumple la propiedad de Markov.
    ]
  ]

]

// *****************************************************************************

#slide(title: "Aprendizaje de la política óptima")[

  Nuestro objetivo es hacer que el agente aprenda una #alert[*política de comportamiento óptima*] que le permita alcanzar sus objetivos $dots$

  $dots$ y, por tanto, #alert[maximizar la recompensa acumulada] (retorno).

  Esto se traduce en asignar una mayor probabilidad a aquellas acciones que conduzcan a una mayor recompensa a largo plazo.

  #shadow[Para guiar al agente en el proceso de aprendizaje empleamos #alert[*funciones de valor*].]

]

// *****************************************************************************

#new-section-slide("Funciones de valor y optimalidad")

// *****************************************************************************

#slide(title: "Funciones de valor")[

  Utilizamos #alert[*funciones de valor*] para evaluar la _calidad_ de #alert[estados] y #alert[acciones].

  #v(1cm)

  #columns(2, gutter: 40pt)[

    #align(center)[*FUNCIÓN ESTADO-VALOR*
      #shadow[
        #text(size: 25pt)[$ v_pi (s) = EE[G_t|S_t=s] $]
      ]
    ]

    _*Retorno esperado* al visitar el estado $s$ y seguir una política $pi$._

    #colbreak()

    #align(center)[*FUNCIÓN ACCIÓN-VALOR*
      #shadow[
        #text(size: 25pt)[$ q_pi (s,a) = EE[G_t|S_t=s, A_t=a] $ ]
      ]
    ]

    _*Retorno esperado* al realizar la acción $a$ desde el estado $s$ y seguir una política $pi$._

  ]

]

// *****************************************************************************

#slide(title: "Funciones de valor")[

  Si desarrollamos estas fórmulas tenemos:

  #v(1cm)

  #columns(2, gutter: 10pt)[
    #text(size: 21pt)[
      #shadow[
        $
          v_pi (s) &= EE_pi [G_t| S_t = s] \
          &= EE_pi [sum_(k=0)^infinity gamma^k R_(t+k+1) | S_t = s]
        $
      ]

      #colbreak()

      #shadow[
        $
          q_pi (s,a) &= EE_pi [G_t| S_t = s, A_t = a] \
          &= EE_pi [sum_(k=0)^infinity gamma^k R_(t+k+1) | S_t = s, A_t = a]
        $
      ]
    ]
  ]

  #v(1cm)

  #text(size: 16pt)[- _Suma de las recompensas descontadas desde $t$ en adelante_.]

]

// *****************************************************************************

#slide(title: "Pregunta...")[

  #align(center)[
    _¿Cuál es la diferencia entre *valor* y *recompensa*?_
  ]

  #v(1cm)

  #pause

  #shadow[
    - #alert[Recompensa] $->$ es una señal *inmediata* que el agente recibe después de realizar una acción o transicionar a un estado.

    - #alert[Valor] $->$ es una estimación de las *recompensas* a obtener a largo plazo (_retorno_).
  ]

]

// *****************************************************************************

#focus-slide("Ecuaciones de Bellman")

// *****************************************************************************

#let ebv = text[Ecuación de Bellman para $v_pi$]

#slide(title: [#ebv])[

  #let a = text[Probabilidad\ de elegir\ cada acción]
  #let b = text[Probabilidad\ de transición]
  #let c = text[Recompensa\ inmediata +\ futura\ descontada]

  La *ecuación de Bellman* para $v_pi$ es la _definición recursiva_ de la #alert[función estado-valor]:

  #v(0.5cm)

  #text(size: 20pt)[
    #align(center)[
      #alternatives-match((
        "1": [
          $
            v_pi (s) &= EE_pi [G_t|S_t=s] \
            &= EE_pi [R_(t+1) + gamma G_(t+1) | S_t = s] \
            &= sum_a pi(a|s) sum_(s',r) p(s',r|s,a)[r+gamma v_pi (s')]
          $
          #v(1cm)
        ],
        "2": [
          $
            v_pi (s) &= EE_pi [G_t|S_t=s] \
            &= EE_pi [R_(t+1) + gamma G_(t+1) | S_t = s] \
            &= colmath(underbracket(sum_a pi(a|s), #a), #red) colmath(underbracket(sum_(s',r) p(s',r|s,a), #b), #blue) colmath(underbracket([r+gamma v_pi (s')], #c), #olive)
          $
        ],
      ))
    ]
  ]

  #pause

  #v(1cm)
  #text(size: 15pt)[_Si el problema es determinista, $sum_(s',r) p(s', r|s,a)$ se elimina de la ecuación de Bellman._]
]

// *****************************************************************************

#slide(title: [#ebv])[

  La *ecuación de Bellman* tiene en cuenta todas las probabilidades de transición, ponderando las #text(fill:orange)[recompensas obtenibles] por su #text(fill:eastern)[probabilidad].

  #v(1cm)

  $
    v_pi(s) &= EE_pi [G_t|S_t=s] \
    &= EE_pi [R_(t+1) + gamma G_(t+1) | S_t = s] \
    &= colmath(sum_a pi(a|s) sum_(s',r) p(s',r|s,a), #eastern) colmath([r+gamma v_pi (s')], #orange)
  $

]

// *****************************************************************************

#let bgv = text[Diagrama _backup_ para $v_pi$]

#slide(title: [#bgv])[

  #columns(2, gutter: 30pt)[

    #v(2cm)

    Los #alert[diagramas _backup_] representan cómo se transfiere la información sobre los valores desde estados sucesores hasta el estado actual.

    - Similar para pares _acción-estado_.

    #colbreak()

    #image("images/backup-v.png", width: 150%)

  ]

]


// *****************************************************************************

#let ebq = text[Ecuación de Bellman para $q_pi$]

#slide(title: [#ebq])[

  #let a = text[Probabilidades de transición\ (dependiente del entorno)]
  #let b = text[Recompensa\ inmediata]
  #let c = text[Recompensa futura\, ponderada\ por la prob. de cada acción]

  De forma análoga, esta es la *definición recursiva* de la #alert[función acción-valor]:

  #text(size: 19pt)[
    #align(center)[
      #alternatives(position: center + horizon)[
        $
          q_pi (s,a) &= EE_pi [G_t|S_t=s, A_t=a] \
          &= sum_(s',r) p(s',r|s,a)[r+gamma EE_pi [G_(t+1) | S_(t+1) = s']] \
          &= sum_(s',r) p(s',r|s,a)[r+gamma sum_(a') pi(a'|s') q_pi (s',a')]
        $
      ][
        $
          q_pi (s,a) &= EE_pi [G_t|S_t=s, A_t=a] \
          &= sum_(s',r) p(s',r|s,a)[r+gamma EE_pi [G_(t+1) | S_(t+1) = s']] \
          &= colmath(underbracket(sum_(s',r) p(s',r|s,a), #a), #olive) [
            colmath(underbracket(r, #b), #red)+colmath(underbracket(gamma sum_(a') pi(a'|s') q_pi (s',a'), #c), #blue)
          ]
        $
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Políticas y funciones de valor")[

  #box(height: 400pt)[
    Podemos comparar políticas y establecer un #alert[orden] entre ellas empleando las funciones de valor:
    #align(center)[
      #shadow[
        #text(size: 20pt)[
          $ pi >= pi' <=> v_pi (s) >= v_pi' (s), #h(0.5cm) forall s in cal(S) $
        ]
      ]
      #align(center)[#image("images/policies-1.png", width: 40%)]
    ]
  ]
]

// *****************************************************************************

#slide(title: "Políticas óptimas")[

  Siempre existirá, al menos, una política mejor que cualquier otra, denominada #alert[*política óptima*], $pi^*$.

  #h(1cm) #emoji.warning Puede haber más de una política óptima.

  Las políticas óptimas comparten la misma #alert[*función estado-valor óptima*] $v^*$:

  #align(center)[
    #shadow[
      $ v^* (s) = max_pi #h(0.2cm) v_pi (s), #h(0.5cm) forall s in cal(S) $
    ]
  ]

  - La función estado-valor óptima es la función estado-valor con el valor más alto entre todas las políticas.

  - La función estado-valor óptima es *única*.

]

// *****************************************************************************

#slide(title: "Políticas óptimas")[

  #box(height: 500pt)[
    #align(center)[#image("images/policies-values.png", width: 105%)]
  ]

]

// *****************************************************************************

#slide(title: "Combinación de políticas")[

  #box(height: 300pt)[

    Podemos *combinar* políticas subóptimas para formar políticas mejores:

    #v(0.7cm)

    #columns(2, gutter: 10pt)[
      #align(center)[#image("images/policies-2.png", width: 90%)]
      #align(center)[#image("images/policies-3.png", width: 90%)]
    ]

    #text(size: 18pt)[No es necesario hacer sacrificios en determinados estados tomando acciones subóptimas.]

  ]

]

// *****************************************************************************

#slide(title: "Función acción-valor óptima")[

  Las políticas óptimas también comparten la misma #alert[*función _acción-valor_ óptima*]:

  #text(size: 20pt)[
    #align(center)[
      #shadow[
        $ q^*(s,a) = max_pi q_pi (s,a), #h(0.5cm) forall s in cal(S), a in cal(A) $
      ]
    ]
  ]

  También podemos definir $q^*$ en términos de $v^*$ tal que:

  #v(0.1cm)

  #text(size: 20pt)[
    #align(center)[
      #shadow[
        $ q^* (s,a) = EE [R_(t+1) + gamma v^*(S_(t+1)) | S_t = s, A_t = a] $
      ]
    ]
  ]

  #v(1cm)

  #text(size: 15pt)[
    _$q^*$ asocia a cada par acción-estado una recompensa esperada igual a la recompensa inmediata + recompensa (descontada) futura de acuerdo a la función de valor óptima $v^*$._
  ]
]

// *****************************************************************************

#focus-slide("Ecuaciones de optimalidad de Bellman")

// *****************************************************************************

#let opv = text[Ecuación de optimalidad de Bellman para $v^*$]

#slide(title: [#opv])[

  La #alert[*función _estado-valor_ óptima*] $v^*$ puede definirse tal que:

  #v(1cm)

  #align(center)[
    #alternatives(position: center + horizon)[
      $
        v^* (s) &= max_(a in cal(A)(s)) q_(pi^*)(s,a) \
        &= max_a EE[R_(t+1) + gamma v^*(S_(t+1)) | S_t = s, A_t = a] \
        &= max_a sum_(s',r) p(s',r|s,a)[r+gamma v^*(s')] \
      $
    ][
      $
        v^* (s) &= max_(a in cal(A)(s)) q_(pi^*)(s,a) \
        &= colmath(max_a EE[R_(t+1) + gamma v^*(S_(t+1)) | S_t = s, A_t = a] #h(2cm) (op("Eq. 1")), #blue) \
        &= colmath(max_a sum_(s',r) p(s',r|s,a)[r+gamma v^*(s')] #h(2cm) (op("Eq. 2")), #olive)
      $
    ]
  ]

  #v(1cm)
  #text(size: 15pt)[
    _El valor óptimo de un estado será aquel asociado a seguir una acción óptima desde este en adelante_.
  ]
]

// *****************************************************************************

#let opq = text[Ecuación de optimalidad de Bellman para $q^*$]

#slide(title: [#opv])[

  La #alert[*función de _acción-valor_ óptima*] $q^*$ puede definirse tal que:

  #v(1cm)

  $
    q^* (s,a) &= EE[R_(t+1) + gamma max_a' q^*(S_(t+1), a') | S_t = s, A_t = a] \
    &= sum_(s',r) p(s',r|s,a)[r+gamma max_a' q^*(s',a')] \
  $

]

// *****************************************************************************

#let bk = text[Diagramas _backup_ para ecuaciones de optimalidad]

#slide(title: [#bk])[

  #align(center)[#image("images/backup.png", width: 100%)]

]

// *****************************************************************************

#slide(title: "Obtención de la política óptima")[

  #shadow[Conociendo $v^*$ podemos extraer fácilmente la política óptima, ya que #alert[cualquier política que actúa de forma _greedy_ con respecto a $v^*$ es óptima:]]

  #h(1cm) 1. Examinar el valor de los sucesores de $s$.\
  #h(1cm) 2. Transición al $s'$ de mayor valor (asumiendo que $v^*$ es óptima).

  #shadow[Conocer $q^*$ hace que el proceso de obtención de la política óptima sea incluso #alert[más sencillo]:]

  #h(1cm) 1. Para cualquier estado $s$, se emplea la acción que maximice $q^*(s,a)$.

]

// *****************************************************************************

#slide(title: "Resolución de las ecuaciones de optimalidad de Bellman")[

  En MDPs finitos, las ecuaciones de optimalidad de Bellman tienen #alert[soluciones únicas].

  - Definimos una ecuación por estado.
  - Dados #text(fill:red)[$n$ estados], tenemos #text(fill:red)[$n$ ecuaciones lineales] y, por tanto, #text(fill:red)[$n$ incógnitas].

  La resolución del sistema de ecuaciones nos permite obtener la *política óptima*.

  #align(center)[#image("images/solver.png", width: 60%)]

]

// *****************************************************************************

#slide(title: "Resolución de las ecuaciones de optimalidad de Bellman")[

  No obstante, esto implica dar por supuestos tres aspectos fundamentales que rara vez se dan en la práctica:

  #shadow[
    1. Conocimiento preciso/completo de las *dinámicas del entorno*.
    2. *Recursos computacionales* suficientes para calcular la solución.
    3. El cumplimiento de la *propiedad de Markov*.
  ]

  Esto motiva el uso de métodos alternativos basados en la #alert[aproximación] de la solución.
]

// *****************************************************************************

#slide(title: "Resolución de las ecuaciones de optimalidad de Bellman")[

  A pesar de que se cumpliesen las condiciones:

  #shadow[
    1. Conocimiento preciso/completo de las *dinámicas del entorno*. #emoji.checkmark.box
    3. El cumplimiento de la *propiedad de Markov*. #emoji.checkmark.box
  ]

  normalmente no es posible lidiar con:

  #shadow[
    2. *Recursos computacionales* suficientes para calcular la solución. #emoji.crossmark
  ]

  especialmente en problemas complejos con un gran número de estados/acciones.
]

// *****************************************************************************

#slide(title: "Resolución de las ecuaciones de optimalidad de Bellman")[

  #box(height: 500pt)[
    #align(center)[#image("images/schema.png", width: 100%)]
  ]
]

// *****************************************************************************

#new-section-slide("Trabajo propuesto")

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  #text(size: 18pt)[

    - Leer sobre otros tipos de *MDPs* / *POMDPs* y conocer sus diferencias.

    - Familiarización con la API de #alert[*Gymnasium*]:
      #text(size: 16pt)[
        - https://gymnasium.farama.org/
        - Implementación de un *agente aleatorio* sobre un entorno de ejemplo.
        - Implementación de un *agente basado en reglas* sobre el mismo entorno.
      ]

    - *Resolver* un MDP sencillo mediante un *sistema de ecuaciones* lineal.

    - #alert[*Función de ventaja*] (_advantage function_):
      - ¿Qué es?
      - ¿En qué se diferencia de las funciones de valor estudiadas?

    === Bibliografía y vídeos:
    #text(size: 15pt)[
      - https://youtu.be/lfHX2hHRMVQ?si=2jR4HI72ReErh7rb
      - https://web.stanford.edu/class/cme241/lecture_slides/david_silver_slides/MDP.pdf
    ]
  ]
]

// *****************************************************************************

#title-slide(
  author: [Antonio Manjavacas Lucas],
  title: "Procesos de decisión de Markov",
  subtitle: "Procesos de decisión de Markov",
  extra: "manjavacas@ugr.es",
)

