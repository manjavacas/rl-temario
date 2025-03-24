#import "@preview/typslides:1.2.5": *

#show: typslides.with(
  ratio: "16-9",
  theme: "reddy",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)

#let colmath(x, color: red) = text(fill: color)[$#x$]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Métodos basados en muestreo",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents(title: "Contenidos")

// *****************************************************************************


#slide(title: "Limitaciones de la programación dinámica")[

  #box(height: 400pt)[
    Hemos visto que los algoritmos de #stress[programación dinámica] son *poco escalables* a medida que el tamaño del *espacio de estados/acciones* aumenta.

    Además, asumíamos algo que rara vez se da en la práctica: la disponibilidad y conocimiento íntegro de un #stress[modelo del entorno].

    - Son métodos _model-based_.


    #framed[#emoji.quest ¿Existe una forma más sencilla/escalable de obtener el valor de los diferentes estados/acciones?]

    Recordemos que #stress[_valor de un estado_ = _retorno esperado_], esto es:
    #grayed[
      $ v_pi (s) = EE_pi [G_t | S_t = s] $
    ]
  ]
]

// *****************************************************************************

#focus-slide(text-size: 43pt)[Métodos basados en muestreo \ #text(size:19pt)[_Sample-based learning methods_]]

// *****************************************************************************

#let sm = text[Métodos basados en _sampling_]

#slide(title: [#sm])[

  Los #stress[métodos basados en _sampling_] (muestreo) ofrecen una serie de ventajas que facilitan la estimación de valores/obtención de políticas óptimas en MDPs.

  - Su principal ventaja es que *no requieren un modelo del entorno*.

  En términos generales, su funcionamiento consiste en:

  #framed[
    1. Acumular #stress[experiencia] mediante la #stress[interacción] con el entorno.
    2. *PREDICCIÓN*: estimar el valor de estados/acciones.
    3. *CONTROL*: obtener la política óptima asociada.
  ]

  Comenzaremos estudiando los métodos Monte Carlo, y posteriormente veremos otras alternativas.

]

// *****************************************************************************

#title-slide([Predicción Monte Carlo])

// *****************************************************************************

#slide(title: "Predicción Monte Carlo")[

  #framed(title: "Método Monte Carlo")[
    Técnica computacional empleada para estimar resultados mediante la generación de múltiples muestras aleatorias.
  ]

  #v(.3cm)

  La idea básica detrás de la #stress[prediccón Monte Carlo] (_Monte Carlo prediction_) es seguir múltiples trayectorias aleatorias desde diferentes estados.

  - Para aproximar el valor de un estado, calculamos la *media* de las recompensas acumuladas obtenidas cada vez que se visitó.

  - No requiere un *modelo* del entorno (es #stress[_model-free_]).

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #figure(image("images/mc-sample.png"))

]

// *****************************************************************************

#slide(title: "Predicción Monte Carlo")[


  #grid(
    columns: (3fr, 1fr),
    grid.cell(
      box[
        #framed[Monte Carlo requiere solamente #stress[experiencia.]]

        - No asume conocimiento alguno de las *dinámicas del entorno*... $p(s',r|s,a)$.

        - No emplea valores esperados, sino *resultados empíricos*.
      ],
    ),
    grid.cell(align(center)[#image("images/dice.png", width: 70%)])
  )

  #framed[Permite la resolución de problemas de RL a partir del *promedio de las recompensas finales obtenidas* (_average sample returns_).]

  - Se trata de un #stress[proceso de mejora episodio-a-episodio], ya que solamente conocemos el _return_ (recompensa acumulada final) al terminar un episodio.

  - Decimos que es un aprendizaje #stress[basado en resultados completos] (_vs._ parciales).

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height: 400pt)[

    Tratamos de estimar $v(s)$, con $gamma = 0.5$

    - Recordemos que $v(s) = EE[G_t | S_t = s]$

    Comenzamos realizando una #stress[trayectoria aleatoria]:

    #v(1cm)

    #align(center)[#image("images/mc-bot-1.png", width: 105%)]

  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height: 400pt)[

    Acumulamos #stress[experiencia]...

    #v(1cm)

    #align(center)[#image("images/mc-bot-2.png", width: 105%)]

  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #v(1cm)
  #align(center + top)[#image("images/mc-bot-2.png", width: 105%)]

  Calculamos el #stress[retorno] para cada estado:

  #v(0.9cm)

  #columns(2)[

    $ G_0 = R_1 + gamma G_1 $
    $ G_1 = R_2 + gamma G_2 $
    $ G_2 = R_3 + gamma G_3 $

    #colbreak()

    $ G_3 = R_4 + gamma G_4 $
    $ G_4 = R_5 + gamma G_5 $
    $ G_5 = colmath(0) $
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #v(1cm)
  #align(center + top)[#image("images/mc-bot-2.png", width: 105%)]

  #cols[

    $G_0 = R_1 + gamma G_1 colmath(= 3 + 0.5 dot 8 = 7)$

    $G_1 = R_2 + gamma G_2 colmath(= 4 + 0.5 dot 8 = 8)$

    $G_2 = R_3 + gamma G_3 colmath(= 7 + 0.5 dot 2 = 8)$

  ][

    $G_3 = R_4 + gamma G_4 colmath(= 1 + 0.5 dot 2 = 2)$

    $G_4 = R_5 + gamma G_5 colmath(= 2 + 0.5 dot 0 = 2)$
    $ G_5 = colmath(0) $
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  Valores estimados:

  #v(1cm)

  #align(center)[#image("images/mc-bot-3.png", width: 105%)]

]

// *****************************************************************************

#slide(title: "Predicción Monte Carlo")[

  #figure(image("images/mc-algo.png"))

]

// *****************************************************************************

#let fvev = text[Predicción _First-visit_ _vs._ _Every-visit_ ]

#slide(title: [#fvev])[

  - Denominamos a este método #stress[_First-visit Monte Carlo prediction_], porque sólo tenemos en cuenta la recompensa obtenida en la *primera visita* a cada estado.

  - Una alternativa es #stress[_Every-visit Monte Carlo prediction_], que tiene en cuenta *todas las visitas* a un mismo estado.

  #v(1cm)

  #text(size: 22pt)[
    #align(center)[#framed[Ambos convergen en $v_pi (s)$]]
  ]

  #v(1cm)

  Veamos exactamente en qué se diferencian...

]

// *****************************************************************************

#slide(title: [#fvev])[

  #cols[
    #align(center)[#image("images/fv-mc.png", width: 110%)]
  ][
    #align(center)[#image("images/ev-mc.png", width: 111%)]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/fv-ev-example.png", width: 105%)
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #framed[
    #stress[_FIRST-VISIT_ MC]\
    Consideramos las recompensas acumuladas a partir de la primera visita.
  ]

  #align(center + top)[
    #image("images/fv-example.png", width: 85%)
  ]

  #columns(3, gutter: 30pt)[
    #text(size: 17pt)[
      *Episodio 1: *

      $V(s_1) = 3+2+ -4 +4 -3 = bold(2)\ V(s_2) = -4 + 4 - 3 = bold(-3)$

      #colbreak()

      *Episodio 2: *

      $V(s_1) = 3 -3 = bold(0)\ V(s_2) = -2 + 3 -3 = bold(-2)$

      #colbreak()

      #grayed[
        #set text(size: 20pt)
        $V(s_1) = (2+0) / 2 = bold(1)$\ #v(0.4cm) $V(s_2) = (-3 -2) / 2 = bold(2.5)$
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #box(height: 400pt)[
    #framed[#stress[_EVERY-VISIT_ MC] \ Consideramos las recompensas acumuladas a partir todas las visitas.]

    #align(center + top)[
      #image("images/ev-example.png", width: 75%)
    ]

    #columns(2, gutter: 170pt)[
      #text(size: 17pt)[

        *Episodio 1: *

        $V(s_1) = (3+2-4+4-3) + (2-4+4-3) + (4-3) = bold(2)\ V(s_2) = (-4+4-3)+(-3)= bold(0)$

        #colbreak()

        *Episodio 2: *

        $V(s_1) = 3 -3 = bold(0)\ V(s_2) = (-2 + 3 -3) + (-3) = bold(1)$


      ]
    ]

    #align(center)[
      #grayed[
        #set text(size: 18pt)
        $V(s_1) = (2-1+1+0) / 4 = bold(0.5)$ #h(4cm) $V(s_2) = (-3 -3 -2 -3) / 4 = bold(2.75)$
      ]
    ]
  ]
]


// *****************************************************************************

#slide(title: "Predicción Monte Carlo")[

  MC es una solución relativamente simple para aproximar funciones de valor/evaluar políticas.

  #framed[
    Un aspecto importante de MC es que la estimación del valor de un estado #stress[*NO* depende de las estimaciones de valor de otros estados].

    - El #stress[valor de cada estado es independiente del resto], y *sólo depende de la recompensa acumulada al final del episodio*.

    - Es decir, no se emplea #stress[_bootstrapping_] (#stress[estimaciones a partir de estimaciones]).
  ]

  Esto puede ser útil cuando solamente queremos saber el valor de un subconjunto de estados (ignorando el resto).

]


// *****************************************************************************

#let bmc = text[Diagrama _backup_ de MC]

#slide(title: [#bmc])[

  #cols[

    El diagrama *_backup_* del método Monte Carlo representa cómo las estimaciones de valor de los estados requieren llegar hasta #stress[el final del episodio].

    #v(1cm)

    Una vez obtenido el *retorno* (es decir, la #stress[recompensa acumulada al final del episodio]), dicha información se propaga hacia atrás.

  ][

    #align(center)[#image("images/backup-mc.png")]
  ]
]

// *****************************************************************************

#slide(title: [#bmc])[

  #columns(2)[

    Si comparamos con los diagramas de los algoritmos de programación dinámica...

    #align(center)[#image("images/backup-dp.png", width: 110%)]

    #v(.5cm)

    - MC *no emplea _bootstrapping_*.
    - MC permite estimaciones para *subconjuntos de estados*.

    #colbreak()

    #align(center)[#image("images/backup-mc.png")]

  ]
]

// *****************************************************************************

#slide(title: "Estimación de valores de acción con MC")[

  Si no contamos con un modelo del entorno, es particularmente útil tratar de estimar directamente los #stress[_action-values_] (_vs. state-values_).

  #framed[#stress[Con un modelo del entorno], los valores de los estados son suficientes para saber qué política seguir.]

  - Se mira "un paso adelante" y se decide a qué nuevo estado ir.

  #framed[#stress[Sin un modelo], los valores de los estados *NO* son suficientes.]

  - Es necesario estimar de forma explícita el valor de cada acción.
  - Saber qué acción realizar en cada estado nos conduce directamente a una *política óptima*.

]

// *****************************************************************************

#slide(title: "Estimación de valores de acción con MC")[

  #framed[*Con un modelo del entorno*, el agente sólo tiene que estimar los valores de los estados y actuar de forma _greedy_ para alcanzar su objetivo.]

  #align(center)[#image("images/with-model.png")]

]

// *****************************************************************************

#slide(title: "Estimación de valores de acción con MC")[

  #box(height: 400pt)[
    #framed[*Sin un modelo del entorno*, el agente necesita estimar los valores de cada par acción-estado...]

    #v(0.2cm)

    #align(center)[#image("images/without-model.png")]

    El agente aprende a elegir la mejor acción para cada estado $-->$ está aprendiendo directamente la *política óptima*.
  ]
]

// *****************************************************************************

#title-slide([Control Monte Carlo])

// *****************************************************************************

#slide(title: "Control Monte Carlo")[

  #framed[#emoji.quest #h(0.5cm) ¿Cómo utilizar Monte Carlo para aproximar políticas óptimas?]

  Seguiremos la idea de #stress[GPI] (_Iteración de la Política Generalizada_), aplicando hasta convergencia:

  1. #stress[Evaluación] de la política
  2. #stress[Mejora] de la política

  #grayed[$ pi_0 -> q_0 -> pi_1 -> q_1 -> dots -> pi_* -> q_* $]

]

// *****************************************************************************

#slide(title: "GPI con Monte Carlo")[

  #cols[

    _*Recordemos...*_

    En GPI se mantiene una *función de valor* y una *política* aproximadas.

    #emoji.chart.bar La #stress[función de valor] se actualiza progresivamente hasta aproximarse a la función de valor de la política actual.

    #emoji.chart.up Por otro lado, la #stress[política] siempre se mejora con respecto a la función de valor actual (de forma _greedy_).
  ][

    #align(center)[#image("images/iteration-loop.png", width: 60%)]
  ]

]

// *****************************************************************************

#slide(title: "GPI con Monte Carlo")[


  #cols[

    _*Recordemos...*_

    #grayed[
      #set text(size: 20pt)
      $ pi_0 ->^E q_pi_0 ->^I pi_1 ->^E q_pi_1 ->^I dots ->^I pi^* ->^E q_(pi^*) $
    ]

    Para cada función de valor $q$, la política _greedy_ correspondiente es aquella tal que $forall s in cal(S)$ elige de forma *determinista* una acción con valor máximo:

    #grayed[$ pi(s) = op("argmax")_a q(s,a) $]

  ][

    Es decir, #stress[$pi_(k+1)$ es siempre la política _greedy_ con respecto a $q_pi_k$].

    #v(.5cm)

    #framed[#emoji.books Matemáticamente, se demuestra que cada $pi_(k+1)$ será uniformemente mejor que $pi_k$ o, al menos, igual (en ese caso, ambas políticas son óptimas).]
  ]

]

// *****************************************************************************

#slide(title: "GPI con Monte Carlo")[

  #let exp = text(size: 25pt, fill: blue)[empleada\ para\ acumular\ experiencia]
  #let val = text(size: 25pt, fill: olive)[valores\ estimados]
  #let pol = text(size: 25pt, fill: red)[nueva\ política]
  #let new = text(size: 25pt, fill: red)[nueva\ estimación]

  #grayed[
    #set text(size: 30pt)
    $
      underbrace(pi_0, #exp) ->^E underbrace(q_pi_0, #val) ->^I underbrace(pi_1, #pol) ->^E underbrace(q_pi_1, #new) ->^I dots ->^I pi^* ->^E q_(pi^*)
    $
  ]

  De esta forma, MC es capaz de obtener *políticas óptimas* a partir de #stress[episodios muestreados] y sin ningún conocimiento del entorno.

  - La convergencia se alcanza cuando la política y la función de valor son óptimas.

]

// *****************************************************************************

#focus-slide("Ejemplo")

// *****************************************************************************

#slide(title: "Ejemplo")[

  Las recompensas son los valores en cada casilla.
  Asumimos $gamma = 1$.

  #align(center)[#image("images/control-mc.png", width: 40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-0.png", width: 40%)]

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-1.png", width: 40%)]

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-2.png", width: 40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-3.png", width: 40%)]

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-6.png", width: 40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-7.png", width: 40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-8.png", width: 40%)]

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #columns(2)[

    #align(center)[#image("images/q-s6.png", width: 100%)]

    #colbreak()

    #v(2cm)

    $ q(s_6, #emoji.arrow.b.filled) = 10 $
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[


  #columns(2)[

    #align(center)[#image("images/q-s3.png", width: 100%)]

    #colbreak()

    #v(2cm)

    $ q(s_6, #emoji.arrow.b.filled) = 10 $
    $ q(s_3, #emoji.arrow.b.filled) = (-1) + 10 = 9 $
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #columns(2)[

    #align(center)[#image("images/q-s2.png", width: 100%)]

    #colbreak()

    #v(2cm)

    $ q(s_6, #emoji.arrow.b.filled) = 10 $
    $ q(s_3, #emoji.arrow.b.filled) = 9 $
    $ q(s_2, #emoji.arrow.r.filled) = (-1) + 9 = 8 $
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #columns(2)[

    #align(center)[#image("images/q-s5.png", width: 100%)]

    #colbreak()

    #v(2cm)

    $ q(s_6, #emoji.arrow.b.filled) = 10 $
    $ q(s_3, #emoji.arrow.b.filled) = 9 $
    $ q(s_2, #emoji.arrow.r.filled) = 8 $
    $ q(s_5, #emoji.arrow.t.filled) = (-1) + 8 = 7 $
  ]


]

// *****************************************************************************

#slide(title: "Ejemplo")[


  #columns(2)[

    #align(center)[#image("images/q-s4.png", width: 100%)]

    #colbreak()

    #v(2cm)

    $ q(s_6, #emoji.arrow.b.filled) = 10 $
    $ q(s_3, #emoji.arrow.b.filled) = 9 $
    $ q(s_2, #emoji.arrow.r.filled) = 8 $
    $ q(s_5, #emoji.arrow.t.filled) = 7 $
    $ q(s_4, #emoji.arrow.r.filled) = (-1) + 7 = 6 $
  ]


]
// *****************************************************************************

#slide(title: "Ejemplo")[


  #columns(2)[

    #align(center)[#image("images/q-s1.png", width: 100%)]

    #colbreak()

    #v(2cm)

    $ q(s_6, #emoji.arrow.b.filled) = 10 $
    $ q(s_3, #emoji.arrow.b.filled) = 9 $
    $ q(s_2, #emoji.arrow.r.filled) = 8 $
    $ q(s_5, #emoji.arrow.t.filled) = 7 $
    $ q(s_4, #emoji.arrow.r.filled) = 6 $
    $ q(s_1, #emoji.arrow.b.filled) = (-1) + 6 = 5 $
  ]


]

// *****************************************************************************

#slide(title: "Ejemplo")[


  #columns(2)[

    #align(center)[#image("images/control-0.png", width: 100%)]

    #colbreak()

    #v(1cm)

    #align(center)[
      #table(
        columns: (auto, auto, auto, auto, auto),
        inset: 10pt,
        fill: (x, y) => if x == 0 or y == 0 { gray.lighten(80%) },
        table.header(
          [],
          [#emoji.arrow.t.filled],
          [#emoji.arrow.b.filled],
          [#emoji.arrow.l.filled],
          [#emoji.arrow.r.filled],
        ),

        [$s_1$], [], [#stress[5]], [], [],
        [$s_2$], [], [], [], [#stress[8]],
        [$s_3$], [], [#stress[9]], [], [],
        [$s_4$], [], [], [], [#stress[6]],
        [$s_5$], [#stress[7]], [], [], [],
        [$s_6$], [], [#stress[10]], [], [],
        [$s_7$], [], [], [], [],
        [...], [...], [...], [...], [...],
      )
    ]
  ]

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[
    _Siguiente iteración..._
    #align(center)[#image("images/control-0.png", width: 40%)]
  ]
]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-1.png", width: 40%)]

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-10.png", width: 40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-11.png", width: 40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #columns(2)[

    #align(center)[#image("images/q-s7.png", width: 70%)]

    #colbreak()

    #v(2cm)

    $ q(s_7, #emoji.arrow.r.filled) = -10 $
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #columns(2)[

    #align(center)[#image("images/q-s4-2.png", width: 70%)]

    #colbreak()

    #v(2cm)

    $ q(s_7, #emoji.arrow.r.filled) = -10 $
    $ q(s_4, #emoji.arrow.b.filled) = (-1) + (-10) = -11 $
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #columns(2)[

    #align(center)[#image("images/q-s1.png", width: 70%)]

    #colbreak()

    #v(2cm)

    $ q(s_7, #emoji.arrow.r.filled) = -10 $
    $ q(s_4, #emoji.arrow.b.filled) = -11 $
    $ q(s_1, #emoji.arrow.b.filled) = (-1) + (-11) = -12 $
  ]


]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height: 400pt)[
    #columns(2)[

      #align(center)[#image("images/control-0.png", width: 100%)]

      #colbreak()

      #v(0.65cm)

      #align(center)[
        #table(
          columns: (auto, auto, auto, auto, auto),
          inset: 12pt,
          fill: (x, y) => if x == 0 or y == 0 { gray.lighten(80%) },
          table.header(
            [],
            [#emoji.arrow.t.filled],
            [#emoji.arrow.b.filled],
            [#emoji.arrow.l.filled],
            [#emoji.arrow.r.filled],
          ),

          [$s_1$], [], [#stress[$(5+(-12)) / 2 = -3.5$]], [], [],
          [$s_2$], [], [], [], [8],
          [$s_3$], [], [9], [], [],
          [$s_4$], [], [#stress[-11]], [], [6],
          [$s_5$], [7], [], [], [],
          [$s_6$], [], [10], [], [],
          [$s_7$], [], [], [], [#stress[-10]],
          [...], [...], [...], [...], [...],
        )
      ]
    ]
  ]

]


// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[#image("images/later.jpg")]
]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height: 400pt)[
    #columns(2)[

      #align(center)[#image("images/control-0.png", width: 100%)]

      #colbreak()

      #align(center)[
        Los *valores* convergen...
        #table(
          columns: (auto, auto, auto, auto, auto),
          inset: 10pt,
          fill: (x, y) => if x == 0 or y == 0 { gray.lighten(80%) },
          table.header(
            [],
            [#emoji.arrow.t.filled],
            [#emoji.arrow.b.filled],
            [#emoji.arrow.l.filled],
            [#emoji.arrow.r.filled],
          ),

          [$s_1$], [6], [7], [6], [7],
          [$s_2$], [7], [8], [6], [8],
          [$s_3$], [8], [9], [7], [8],
          [$s_4$], [6], [6], [7], [8],
          [$s_5$], [7], [-10], [7], [9],
          [$s_6$], [8], [10], [8], [9],
          [$s_7$], [7], [6], [6], [-10],
          [$s_8$], [-], [-], [-], [-],
          [$s_9$], [-], [-], [-], [-],
        )
      ]
    ]
  ]

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height: 400pt)[
    #columns(2)[

      #align(center)[#image("images/mc-policy.png", width: 100%)]

      #colbreak()

      #align(center)[
        Obtenemos la *política* _greedy_...
        #table(
          columns: (auto, auto, auto, auto, auto),
          inset: 10pt,
          fill: (x, y) => if x == 0 or y == 0 { gray.lighten(80%) },
          table.header(
            [],
            [#emoji.arrow.t.filled],
            [#emoji.arrow.b.filled],
            [#emoji.arrow.l.filled],
            [#emoji.arrow.r.filled],
          ),

          [$s_1$], [6], [#stress[7]], [6], [#stress[7]],
          [$s_2$], [7], [#stress[8]], [6], [#stress[8]],
          [$s_3$], [8], [#stress[9]], [7], [8],
          [$s_4$], [6], [6], [7], [#stress[8]],
          [$s_5$], [7], [-10], [7], [#stress[9]],
          [$s_6$], [8], [#stress[10]], [8], [9],
          [$s_7$], [#stress[7]], [6], [6], [-10],
          [$s_8$], [-], [-], [-], [-],
          [$s_9$], [-], [-], [-], [-],
        )
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Exploración en métodos MC")[

  Un problema de MC a la hora de estimar valores es que algunos pares acción-estado #stress[podrían no visitarse nunca]...

  #align(center)[#image("images/big-problem.png", width: 40%)]

  Si el agente sigue una política completamente aleatoria, es posible que ciertas acciones/estados rara vez se seleccionen, especialmente en *entornos complejos*.

]


// *****************************************************************************

#slide(title: "Exploración en métodos MC")[

  Este #stress[sesgo en la selección de acciones] conduce a una *exploración desigual* y a una *estimación sesgada* de los valores.

  El problema es similar si nos encontramos en un entorno *no determinista*...

  #align(center)[#image("images/mc-problem.png", width: 70%)]
]

// *****************************************************************************

#slide(title: "Exploración en métodos MC")[

  #framed[#emoji.compass #emoji.robot Es necesario favorecer la #stress[exploración] del agente.]

  Debemos asegurar *que todos los pares acción-estado se acaben visitando*. Para ello:

  - Las acciones que puedan tomarse partiendo de un estado $s in cal(S)$ nunca tendrán probabilidad $= 0$ (#stress[política estocástica]).

  - Para evitar problemas asociados a entornos no deterministas (donde las transiciones a algunos estados pueden ser poco frecuentes), podemos emplear #stress[inicios de exploración] (_exploring starts_).
]

// *****************************************************************************

#slide(title: "Inicios de exploración")[

  Se trata de una forma de asegurar #stress[exploración continua].

  - Todo episodio empieza desde un *par estado-acción aleatorio*:

  #let t = text[Dependientes de $pi$,$p$]
  #let m = text[$s_1, a_1, s_2, a_2, dots$]

  #grayed[$ underbrace(#stress[$s_0, a_0$], "Aleatorios"), underbrace(#m, #t) $]

  - Cada par estado-acción tiene una probabilidad *no nula* de ser seleccionado #stress[al principio de un episodio]:

    #grayed[$ mu(s,a) > 0, forall s in cal(S), a in cal(A) $]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/es-0.png")
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/es-1.png")
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/es-2.png")
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/es-3.png")
  ]
]

// *****************************************************************************

#slide(title: "Inicios de exploración")[
  #align(center)[
    #box(height: 500pt)[
      #image("images/mc-exploring-algorithm.png", width: 90%)
    ]
  ]
]


// *****************************************************************************

#slide(title: "Inicios de exploración")[

  El #stress[problema] es que #stress[no siempre podemos emplear inicios de exploración].

  - Existen problemas en los que es difícil comenzar es un par estado-acción aleatorio.

  #framed[Es difícil asegurar que un agente pueda empezar desde toda configuración posible, especialmente en problemas lo suficientemente complejos.]

  #cols[
    #text(size: 17pt)[
      - Problemas con espacios de estados o acciones *continuos*.
      - Ineficiencia: estados o acciones *inaccesibles* desde el estado inicial real.
      - ...

      #stress[¿SOLUCIÓN?]
    ]
  ][
    #align(center)[#image("images/warning.png", width: 40%)]
  ]

]

// *****************************************************************************

#focus-slide("Control MC sin inicios de exploración")

// *****************************************************************************

#let on = text[Métodos _on-policy_]
#let off = text[Métodos _off-policy_]

#slide(title: "Control MC sin inicios de exploración")[

  Vamos a estudiar dos alternativas a MC con inicios de exploración...

]

// *****************************************************************************

#slide[

  #box(height: 400pt)[
    #set text(size: 20pt)

    #framed(title: [#on])[
      #emoji.silhouette Se emplea #stress[una única política] que mejora progresivamente, permitiendo siempre cierta exploración.

      - Mejoran y evalúan constantemente la misma política.
    ]
    #framed(title: [#off])[
      #emoji.silhouette.double El agente aprende una *política objetivo* (#stress[_target policy_]) a partir de datos generados por otra *política exploratoria* (#stress[_behaviour policy_]).

      - La política que empleamos para aprender/explorar "está fuera" (_off_) de la que empleamos para seleccionar acciones.
    ]
  ]

]


// *****************************************************************************

#title-slide([#on])


// *****************************************************************************

#slide(title: [#on])[

  #cols[

    #framed[Los métodos #emoji.silhouette #stress[_on-policy_] emplean *una única política*.]

    Esta política _aspira_ a un comportamiento óptimo, pero siempre debe reservar *cierta probabilidad de explorar*.

    Las políticas empleadas generalmente son #stress[_soft_] ("suaves"), es decir:

    #grayed[$ pi(a|s) > 0 #h(1cm) forall s in cal(S), a in cal(A) $]

  ][
    #align(center)[#image("images/on-policy.png", width: 85%)]
  ]

]


// *****************************************************************************

#slide(title: [#on])[
  #align(center)[
    MC con inicios de exploración es _on-policy_ $dots$

    #h(1cm) $dots$ aunque poco viable, como hemos adelantado.

    #v(1cm)

    #framed[Una opción más apropiada son las #stress[políticas $epsilon$-_greedy_].]
  ]
]



// *****************************************************************************

#let greed = text[Políticas $epsilon$-_greedy_]
#let egreed = text[$epsilon$-_greedy_]

#slide(title: [#greed])[
  #framed[Las políticas #stress[#egreed] son políticas estocásticas que siempre permiten cierta probabilidad $epsilon > 0$ de explorar.]

  #v(.5cm)

  #cols[
    #align(center)[#image("images/egreedy.png")]
  ][
    La #stress[acción _greedy_] es aquella que se elige con mayor probabilidad.

    Eventualmente, el resto de acciones (no óptimas) podrían explorarse con probabilidad $epsilon$.

    - El valor de $epsilon$ puede reducirse gradualmente, hasta que la política sea prácticamente determinista.
  ]
]


// *****************************************************************************

#let soft = text[Políticas $epsilon$-_soft_]
#let esoft = text[$epsilon$-_soft_]

#slide(title: [#soft])[

  #framed[#egreed es un subconjunto de las políticas conocidas como #stress[#esoft.]]

  #v(1cm)

  #cols[
    #align(center)[#image("images/esoft.png", width: 100%)]

  ][

    Siempre permiten cierta exploración.

    En el caso de #egreed: #grayed[$ pi(a|s) >= epsilon/(|A(s)|) $]

  ]
]


// *****************************************************************************

#slide(title: [#soft])[

  - Si $epsilon > 0$ estas políticas nunca pueden ser óptimas. Esto se debe a que *siempre existe cierta probabilidad de realizar acciones sub-óptimas* (explorar).

  - No convergen en una política óptima, pero sí en una #stress[muy aproximada]. Además, evitan emplear inicios de exploración.

  #v(1cm)
  #align(center)[#image("images/on-policy-exp.png", width: 30%)]
]


// *****************************************************************************

#slide(title: [#on])[

  #figure(image("images/on-algo.png", width: 75%))

]


// *****************************************************************************

#let onlim = text[Limitaciones de los métodos _on-policy_]

#slide(title: [#onlim])[

  #cols[

    #framed[#emoji.quest ¿Existe alguna #stress[alternativa] a mantener siempre cierta probabilidad de explorar?]

    - MC _on-policy_ supone aprender una política *muy cercana a la óptima*, pero siempre existe cierta probabilidad de elegir acciones sub-óptimas.

    #framed[Los métodos #emoji.silhouette.double #stress[_off-policy_] son una alternativa.]

  ][

    #align(center)[
      #image("images/onp.png", width: 55%)
    ]

    #align(center)[
      #image("images/offp.png", width: 70%)
    ]

  ]

]

// *****************************************************************************

#title-slide([#off])
