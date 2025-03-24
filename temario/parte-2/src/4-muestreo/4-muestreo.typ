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


// *****************************************************************************

#slide(title: [#off])[

  Los métodos #emoji.silhouette.double #stress[_off-policy_] hacen uso de *dos políticas*:

  #framed[#text(fill:green)[*Política objetivo*] (_target policy_). Destinada a ser óptima.]
  #v(-1cm)
  #framed[#text(fill:blue)[*Política de comportamiento*] (_behaviour policy_). Política exploratoria empleada para "generar comportamiento" (muestrear, acumular experiencia).]

  En este caso, decimos que #stress[el aprendizaje de la política óptima se hace a partir de datos/resultados "fuera" (_off_) de la política objetivo].

  - Es decir, mediante información obtenida por la política de comportamiento.

]

// *****************************************************************************

#slide(title: [#off])[
  #align(center)[#image("images/on-off-example.png", width: 80%)]
]


// *****************************************************************************

#focus-slide("Una analogía...")

// *****************************************************************************

#let offon = text[Ejemplo. _On-policy_ vs. _Off-policy_]

#slide(title: [#offon])[

  #columns(2)[
    #framed[#emoji.silhouette #h(0.2cm) _On-policy_]
    #text(size: 17pt)[
      Imagina que tienes un restaurante favorito al que sueles ir a comer (#stress[acción _greedy_]).

      - Al principio, es posible que tu criterio no sea muy preciso pero, a medida que visitas todos los restaurantes varias veces, cada vez repites más el mismo.

      Algunos días vuelves a otros restaurantes que consideras peores para ver si la calidad ha mejorado (#stress[exploración]).

      - Eventualmente estás abierto a dar una nueva oportunidad a restaurantes peores.

      #colbreak()

      #v(2cm)

      #align(center)[
        #image("images/on-rest.png", width: 70%)
      ]

    ]
  ]

]


// *****************************************************************************

#let offon2 = text[_On-policy_ vs. _Off-policy_]

#slide(title: [#offon])[

  #box(height: 400pt)[

    #framed[#emoji.silhouette.double #h(0.2cm) _Off-policy_]
    #text(size: 17pt)[

      Dejas que otra persona pruebe todos los restaurantes de la ciudad durante un tiempo (#stress[política de comportamiento]). En base a su experiencia, eliges ir siempre al restaurante que te recomiende (#stress[política objetivo]).

      - Tú no pruebas nuevos restaurantes (no exploras), lo hace alguien por ti.

      #align(center)[
        #image("images/off-rest.png", width: 60%)
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: [_Imitation learning_])[

  #framed[
    #emoji.silhouette Los métodos *_on-policy_* son más simples, porque sólo se requiere una política.

    #emoji.silhouette.double Los métodos *_off-policy_* requieren más tiempo para converger y presentan una mayor varianza (cambios de comportamiento más bruscos).
  ]

  #v(1cm)

  - No obstante, son más potentes y generales.

  - De hecho, #stress[son una generalización de los métodos _on-policy_], en el caso concreto en que las políticas objetivo y de comportamiento sean las mismas.

]

// *****************************************************************************

#slide(title: [_Imitation learning_])[

  #framed[#emoji.lightbulb Los algoritmos _off-policy_ suelen emplearse para aprender a partir de datos generados por otro controlador/algoritmo, o por humanos (#stress[_imitation learning_]).]

]

// *****************************************************************************

#slide(title: [#off])[

  #framed[_¿Cuándo es preferible el aprendizaje off-policy?_]

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

  #framed[#stress[Objetivo]: estimar $v_pi$ o $q_pi$ dadas las políticas $pi$ (objetivo) y $b$ (comportamiento).]

  Si queremos emplear episodios de $b$ para estimar valores para $pi$, es necesario que cada acción tomada por $b$ la pueda tomar también $pi$ (al menos, eventualmente).

  Denominamos a esto #stress[supuesto de cobertura]:

  #grayed[$ "Si" pi(a|s) > 0, "entonces" b(a|s) > 0 $]

  - $b$ es una política *estocástica* (no tiene por qué serlo al 100%, puede ser $epsilon$-_greedy_).
  - $pi$ puede ser *determinista* o *estocástica*.

]


// *****************************************************************************

#slide(title: "Políticas objetivo estocásticas")[

  #cols[

    Generalmente consideraremos políticas objetivo $pi$ *deterministas*.
    #v(.4cm)
    Aunque existen problemas donde puede ser útil que $pi$ sea *estocástica*.

  ][

    #align(center)[
      #image("images/pi-policy.png")
    ]
  ]

]


// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/pi-policies.png", width: 80%)
  ]
]


// *****************************************************************************

#slide(title: "Políticas de comportamiento estocásticas")[


  #cols(gutter: 1cm)[

    #framed[¿Para qué una #stress[política objetivo $pi$ estocástica?]]

    En este ejemplo, si $pi$ es *determinista* sólo contemplará una acción por estado, incluso si hay varias acciones óptimas.

    Pero si es *estocástica*, tenemos una política que permite una #stress[mayor variedad de acciones óptimas] para un mismo estado.

  ][

    #align(center)[
      #image("images/pi-policies.png", width: 120%)
    ]
  ]

]


// *****************************************************************************

#slide(title: [#off])[

  Sea como sea la política objetivo $pi$, estamos tratando de obtener $v_pi (s)$ #stress[a partir de experiencia generada por una política $b$ diferente]. Es decir, lo que tenemos es:

  #grayed[$ v_b (s) = EE [G_t | S_t=s] $]

  #framed[El #text(fill:red)[problema] es que las distribuciones de estados y acciones bajo $b$ y $pi$ pueden ser diferentes, dando lugar a un #stress[sesgo].]

  Si un subconjunto de estados es más frecuente siguiendo $b$, entonces $pi$ únicamente contará con información sobre esos estados, ignorando el resto.

  #emoji.lightbulb Una forma de solucionar esto es emplear #stress[_importance sampling_].

]


// *****************************************************************************

#let imp = text[_Importance sampling_]

#focus-slide([#imp])


// *****************************************************************************

#slide(title: [#imp])[

  #framed(title: [#imp])[
    El #stress[muestreo por importancia], o *_importance sampling_* es una técnica empleada en estadística para estimar el valor esperado de una distribución en base a ejemplos muestreados de una distribución diferente.
  ]

  #v(1cm)

  Veamos de forma intuitiva en qué consiste...

]


// *****************************************************************************

#slide(title: [#imp])[

  Quiero obtener: #grayed[$EE[g(X)]$]

  Genero muestras aleatorias de una distribución: #grayed[$X_1, X_2, dots, X_n tilde.op cal(D)$]

  Aproximo el valor esperado con Monte Carlo: #grayed[$EE[g(X)] tilde.eq frac(1,n) sum^n_(i=1) g(X_i)$]
]


// *****************************************************************************

#slide(title: [#imp])[

  Valores de $g(X)$ podrían ser *poco probables* pero con una *contribución muy significativa* sobre $EE[g(X)]$.

  Si no se muestrean durante la estimación Monte Carlo, $EE[g(X)]$ se estimará mal.

  #framed[El #stress[muestreo por importancia] consiste en emplear una distribución "_modificada_" donde los valores más importantes (los que más afectan a la estimación de $EE[g(X)]$) se vuelven *más probables*.]

  - Aseguramos así que sean muestreados y formen parte de la estimación Monte Carlo de $EE[g(X)]$.

  - Para paliar el efecto de este aumento de probabilidad, los valores se escalan dándoles un menor peso al ser muestreados.

]


// *****************************************************************************

#slide(title: [#imp])[
  Muestreamos valores que provienen de la distribución _modificada_:

  #grayed[$Y_1, Y_2, dots, Y_n tilde.op cal(D')$]

  Y aproximamos de la siguiente manera:

  #grayed[$EE[g(Y)] = frac(1,n) sum^n_(i=1) frac(p_cal(D) (Y_i), p_cal(D') (Y_i)) g(Y_i)$]

  Siendo: #grayed[$EE[g(Y)] tilde.eq EE[g(X)]$]

]


// *****************************************************************************

#slide(title: [#imp])[
  #align(center)[
    #image("images/importance-sampling-example.png")
  ]
]


// *****************************************************************************

#slide(title: [#imp])[

  _Intuitivamente_:

  - #text(fill:blue)[Ampliamos] (_scale up_) los eventos que son raros en $cal(D')$ pero comunes en $cal(D)$.

  - #text(fill:red)[Reducimos] (_scale down_) los eventos que son comunes en $cal(D')$ pero raros en $cal(D)$.

  #grayed[$ EE[g(Y)] = frac(1,n) sum^n_(i=1) frac(p_cal(D) (Y_i), p_cal(D') (Y_i)) g(Y_i) $]

]


// *****************************************************************************

#slide(title: [#imp])[

  #grayed[$ EE[g(Y)] = frac(1,n) sum^n_(i=1) frac(p_cal(D) (Y_i), p_cal(D') (Y_i)) g(Y_i) $]

  #text(size: 18pt)[
    #table(
      columns: 2,
      inset: 14pt,
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

  #cols[

    Recordemos el concepto de #stress[*trayectoria*]:

    #grayed[$ tau = {S_t, A_t, S_(t+1), A_(t+1), dots, S_T} $]

    La #stress[probabilidad de realizar una trayectoria $tau$ bajo una política $pi$] es:

    $ "Pr"(tau_pi) = product^(T-1)_(k=t) pi(A_k|S_k) #h(0.1cm) p(S_(k+1) | S_k, A_k) $

  ][

    #align(center)[#image("images/trajectory.png")]
  ]

]


// *****************************************************************************

#slide(title: [#predoffimp])[

  Utilizamos $rho$ para #stress[ponderar las recompensas finales] obtenidas en cada trayectoria.

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


// *****************************************************************************

#slide(title: [#predoffimp])[

  #let a = text(fill: red, size: 20pt)[Retorno obtenido\ tras una serie\ de trayectorias\ siguiendo $b$]
  #let b = text(fill: blue, size: 20pt)[Función\ de valor\ correspondiente\ a la política\ objetivo $pi$]

  #v(1cm)

  Finalmente, lo que tenemos es:

  #grayed[
    $EE[$$underbrace(rho_(t:T-1) G_t, #a)$$| S_t = s] = underbrace(v_pi (s), #b)$
  ]

  #align(center)[
    #framed[Ponderamos la recompensa acumulada obtenida\ tras una trayectoria en base a su probabilidad.]
  ]
]

// *****************************************************************************

#focus-slide("Ejemplo")

// *****************************************************************************

#slide(title: "Ejemplo")[

  La política $b$ interactúa con el entorno durante un episodio y obtiene un retorno $G = 10$.

  #framed[
    Si la trayectoria seguida por $b$ es 3 veces *menos* probable que ocurra empleando $pi$, aumentamos $G times 3$:
  ]

  #grayed[$ pi(a|s) > b(a|s) #h(0.2cm) ("ej." times 3) --> G = 10 times 3 = 30 $]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #framed[
    Si, por el contrario, es *más* probable que ocurra en $b$ que en $pi$, reducimos el valor de G:
  ]

  #grayed[$ pi(a|s) < b(a|s) #h(0.2cm) ("ej." times 0.25) --> G = 10 times 0.25 = 2.5 $]

]

// *****************************************************************************

#let predmcimpt = text[Predicción Monte Carlo\ de $v_pi$ con _importance sampling_]

#focus-slide([#predmcimpt])


// *****************************************************************************

#let predmcimp = text[Predicción MC de $v_pi$ con _importance sampling_]

#slide(title: [#predmcimp])[

  #set text(size: 18pt)

  Dado un conjunto (_batch_) de episodios observados a partir de una política _b_, procedemos a estimar $v_pi$. Tenemos dos opciones:

  - _Importance sampling_ #stress[ordinario]:

  #grayed[$V(s) = frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, |cal(T) (s)|)$]

  - _Importance sampling_ #stress[ponderado]:

  #grayed[$V(s) = frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, sum_(t in cal(T)(s)) rho_(t:T(t)-1))$]


]


// *****************************************************************************

#let predmcimpord = text[Predicción MC de $v_pi$ con _importance sampling_ ordinario]

#slide(title: [#predmcimpord])[

  #grayed[
    $
      V(s) = frac(sum_(t in cal(T)(s)) colmath(rho_(t:T(t)-1), color:#olive) colmath(G_t), colmath(|cal(T) (s)|, color:#blue))
    $
  ]

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

  #grayed[
    $
      V(s) = frac(sum_(t in cal(T)(s)) colmath(rho_(t:T(t)-1), color:#olive) colmath(G_t), colmath(|cal(T) (s)|, color:#blue))
    $
  ]

  #v(.5cm)

  - #stress[_First-visit_]: $cal(T)(s)$ sólo considera los _time steps_ de la primera visita a $s$ en cada episodio.

  - #stress[_Every-visit_]: $cal(T)(s)$ incluye todas las visitas a $s$.

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #grayed[
    $V(s) = frac(sum_(t in cal(T)(s)) colmath(rho_(t:T(t)-1), color:#black) colmath(G_t, color:#black), colmath(|cal(T) (s)|, color:#black))$
  ]

  #text(size: 13pt)[
    _Batch_ de 2 episodios:
  ]

  #align(center)[#image("images/is-mc-ord.png")]

  #columns(2)[

    #align(center)[#framed[#stress[_First-visit_]: $cal(T)(s) = {1,7}$]]

    $ V(s) = frac(rho_(1:3) dot 10 + rho_(7:10) dot 5, 2) $

    #colbreak()

    #align(center)[#framed[#stress[_Every-visit_]: $cal(T)(s) = {1,7,9}$]]

    $ V(s) = frac(rho_(1:3) dot 10 + rho_(7:10) dot 5 + rho_(9:10) dot 5, 3) $

  ]

]


// *****************************************************************************

#slide(title: "Limitaciones")[

  El *_importance sampling_ ordinario* no presenta sesgos (_bias_) en favor de la política de comportamiento $b$, #text(fill:red)[pero puede ser demasiado extremo].

  #framed[Por ejemplo, si una trayectoria es $times 10$ veces más probable bajo $pi$ que bajo $b$, la estimación será diez veces $G$, que se aleja bastante del realmente observado.]

  Se plantea como alternativa el *_importance sampling_ ponderado*:

  #grayed[$ V(s) = frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, sum_(t in cal(T)(s)) rho_(t:T(t)-1)) $]
]


// *****************************************************************************

#slide(title: "Limitaciones")[
  #align(center)[#image("images/ord-imp-examp.png")]
]


// *****************************************************************************

#let predmcimppon = text[Predicción MC de $v_pi$ con _importance sampling_ ponderado]

#slide(title: [#predmcimppon])[

  #grayed[$ V(s) = frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, sum_(t in cal(T)(s)) rho_(t:T(t)-1)) $]

  - Presenta *mayor sesgo*:

    - Si sólo se visita un estado una vez, $v_pi (s) = v_b (s)$, el _importance sampling ratio_ se cancela y hay un sesgo hacia la política de comportamiento.

  - Sin embargo, *la varianza es menor* (actualizaciones menos extremas).

  - Suele ser una mejor opción #emoji.checkmark.box
]

// *****************************************************************************

#focus-slide("Ejemplo")

// *****************************************************************************

#slide(title: "Ejemplo")[

  #grayed[
    #text(size: 27pt)[
      $V(s) = frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, sum_(t in cal(T)(s)) rho_(t:T(t)-1))$
    ]
  ]

  #text(size: 12pt)[
    _Batch_ de 2 episodios:
  ]

  #align(center)[#image("images/is-mc-ord.png")]

  #columns(2)[

    #align(center)[#framed[#stress[_First-visit_]: $cal(T)(s) = {1,7}$]]

    $ V(s) = frac(rho_(1:3) dot 10 + rho_(7:10) dot 5, rho_(1:3) + rho_(7:10)) $

    #colbreak()

    #align(center)[#framed[#stress[_Every-visit_]: $cal(T)(s) = {1,7,9}$]]

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

  La predicción Monte Carlo puede realizarse de forma #stress[incremental].

  - Supongamos una secuencia de retornos: $G_1, G_2, dots, G_(n-1)$ obtenidos partiendo de un mismo estado.

  - Cada retorno tiene una ponderación $W_i = rho_(t_i:T (t_i)-1)$

  - Empleando _importance sampling_ ponderado tenemos:

  #grayed[$ V_n = frac(sum_(k=1)^(n-1) W_k G_k, sum_(k=1)^(n-1) W_k), #h(1cm) n >= 2 $]

]


// *****************************************************************************

#slide(title: "Predicción MC incremental")[

  #grayed[$V_n = frac(sum_(k=1)^(n-1) W_k G_k, sum_(k=1)^(n-1) W_k), #h(1cm) n >= 2$]

  #cols[

    Buscamos #stress[actualizar incrementalmente $V_n$] cada vez que se obtiene un nuevo retorno $G_n$.

    - Para cada estado consideramos $C_n$, que es la suma acumulada de los pesos de los $n$ primeros retornos:

      #grayed[ $ C_(n+1) = C_n + W_(n+1) $]

  ][

    - El cálculo de $W_(n+1)$ es recursivo:

      #grayed[
        $
          W_1 <- rho_(T-1) \
          W_2 <- rho_(T-1) rho_(T-2) \
          W_3 <- rho_(T-1) rho_(T-2) rho_(T-3) \
          dots \
          W_(n+1) <- W_n rho_n
        $

      ]
  ]
]

// *****************************************************************************

#slide(title: "Predicción MC incremental")[

  Así, la *regla de actualización* empleada es:

  #grayed[ $ V_(n+1) = V_n + frac(W_n, C_n)[G_n - V_n], #h(1cm) n >= 1 $]

  _$V$ puede ser el valor de un estado o de un par acción-estado._

  #v(1cm)

  #framed[#emoji.checkmark.box Si bien esta implementación se corresponde con el algoritmo de #stress[predicción _off-policy_ con _importance sampling_ ponderado], también se aplica al caso #stress[_on-policy_] si $pi = b$ ($W$ es siempre $=1$).]

]

// *****************************************************************************

#slide(title: "Predicción MC incremental")[
  #align(center)[
    #image("images/MC-off-inc.png")
  ]
]


// *****************************************************************************

#let conoff = text[Control Monte Carlo\ _off-policy_]

#focus-slide([#conoff])

// *****************************************************************************

#slide(title: [Control Monte Carlo _off-policy_])[
  #align(center)[
    #image("images/MC-control-off.png")
  ]
]


// *****************************************************************************

#focus-slide("En resumen...")


// *****************************************************************************

#slide[

  - Los métodos #stress[Monte Carlo] aprenden funciones de valor y políticas óptimas a partir de experiencia procedente de #stress[episodios muestreados / aleatorios].


  - Las políticas óptimas se aprenden directamente, #stress[sin requerir un modelo del entorno] ni emplear _bootstrapping_ (estimaciones a partir de estimaciones).


  - El esquema general de #stress[GPI] también se aplica a estos métodos (evaluación + mejora de la política).


  - La aproximación de las funciones de valor se realiza en base al #stress[retorno promedio] desde cada estado.

]

// *****************************************************************************

#slide[

  - Para garantizar la exploración, empleamos técnicas como #stress[inicios de exploración], aunque presenta algunas limitaciones.

  - Los métodos #stress[_on-policy_] permiten asegurar la exploración y alcanzar una política muy cercana a la óptima.

  - Los métodos #stress[_off-policy_] emplean dos políticas: una para explorar, y otra para actuar.

  - El uso de dos políticas requiere aplicar #stress[_importance sampling_] ordinario o ponderado para que las estimaciones no estén sesgadas.

]


// *****************************************************************************

#title-slide("Actualización incremental")

// *****************************************************************************

#slide(title: "Actualización incremental")[


  Cuando estudiamos los problemas tipo _bandits_, vimos en qué consistía una #stress[regla de actualización incremental]:

  #grayed[
    $
      "valorEstimado'" <- "valorEstimado" + underbrace(alpha, "step\nsize") dot underbrace(["objetivo" -  "valorEstimado"], "error de estimación")
    $

  ]

  - El #stress[error de estimación] se reduce a medida que las #stress[estimaciones] se acercan al #stress[objetivo].

  - Determina *cuánto* nos hemos equivocado en nuestra estimación más reciente.

]


// *****************************************************************************

#slide(title: "Actualización incremental")[

  En los métodos #stress[Monte Carlo], podemos aplicar esta regla de actualización en la estimación de $v_pi, q_pi$.

  - Por ejemplo, la estimación $V tilde.eq v_pi$ se obtendría tal que:

  #columns(2, gutter: 80pt)[
    #v(.9cm)
    $
      V(S_t) <- V(S_t) + underbracket(alpha, "step\nsize") dot underbracket([underbracket(G_t, "objetivo") - underbracket(V(S_t), "estimación\nactual")], "error de estimación")
    $
    #colbreak()
    #image("images/update.png")
  ]

  #align(center)[#framed[El #stress[objetivo], en este caso, es $G_t$.]]

]

// *****************************************************************************

#slide(title: "Actualización incremental con Monte Carlo")[

  #grayed[$ V(S_t) <- V(S_t) + alpha [G_t - V(S_t)] $]

  - $G_t$ es el *retorno* obtenido a partir del _time step_ $t$.

  - $alpha in (0, 1]$ es un parámetro denominado *_step size_*, que determina el "peso" de la actualización.

  - $G_t - V(S_t)$ es la *diferencia* entre el nuevo valor obtenido y el valor estimado actual. Representa la dirección y magnitud de la actualización de $V(S_t)$.


]

// *****************************************************************************

#focus-slide("Ejemplo")

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/foo-sample-0.png")
    $ alpha = 0.9 $
    $ v (s_0) = bold(0) $
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    *_Episodio 1_*
    #image("images/foo-sample-1.png")

    $ G_t = colmath(+10, color:#olive) $

    $ v (s_0) <- v (s_0) + alpha dot [G_t - v (s_0)] = 0 + 0.9 dot [10 - 0] = bold(9) $

  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    *_Episodio 2_*
    #image("images/foo-sample-2.png")

    $ G_t = colmath(-2) $

    $ v (s_0) <- v (s_0) + alpha dot [G_t - v (s_0)] = 9 + 0.9 dot [-2 - 9] = bold(-0.9) $

  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    *_Episodio 3_*
    #image("images/foo-sample-3.png")

    $ G_t = colmath(+5, color:#olive) $

    $ v (s_0) <- v (s_0) + alpha dot [G_t - v (s_0)] = -0.9 + 0.9 dot [5 - (-0.9)] = bold(4.41) $

  ]
]



// *****************************************************************************

#slide(title: "Limitaciones de Monte Carlo")[
  #framed[Como los métodos #stress[Monte Carlo] emplean el valor de retorno $G$ para aproximar $v_pi, q_pi$, *deben esperar al final del episodio* para actualizar los valores estimados.]

  #align(center)[#image("images/mc-update.png", width: 65%)]

]


// *****************************************************************************

#slide(title: "Limitaciones de Monte Carlo")[

  *LIMITACIONES*

  - En problemas con #stress[episodios muy largos], el aprendizaje basado en MC puede ser demasiado lento.

  - Además, las actualizaciones suelen ser muy extremas (#stress[alta variabilidad]).
    - _Se acumulan múltiples eventos aleatorios a lo largo de una misma trayectoria_.

  - ¿Y qué ocurre si abordamos #stress[problemas continuados], donde no hay un estado final?

  #align(center)[#text(fill: red, size: 30pt)[*¿Alguna alternativa?*]]

]


// *****************************************************************************

#let td = text[_TD-learning_]

#title-slide([#td])


// *****************************************************************************

#slide(title: [#td])[

  #framed(title: [TD-_learning_])[

    El #stress[aprendizaje por diferencia temporal] (_Temporal Difference Learning_ o, abreviado, #stress[_TD-learning_]) es un conjunto de métodos _model-free_ utilizados para estimar funciones de valor mediante actualizaciones iterativas basadas en la diferencia temporal entre predicciones sucesivas.
  ]

  Veamos en detalle en qué se diferencia de MC...

]


// *****************************************************************************

#slide(title: [#td])[

  Tanto #stress[TD] como #stress[MC] se basan en la *experiencia* para resolver el problema de *predicción* de valores.

  - Dado un conjunto de experiencias bajo la política $pi$, actualizan su estimación $V$ de $v_pi$ para todo estado no terminal $S_t$ que tiene lugar durante esa experiencia.

  Como hemos visto, *MC* requiere esperar al *final de episodio* para obtener $G_t$, que es empleado como #stress[objetivo] en la actualización de $V(S_t)$:

  #grayed[$ V(S_t) <- V(S_t) + alpha [colmath(G_t, color:#blue) - V(S_t)] $]

  Decimos que es una *actualización _no sesgada_* del valor estimado.

]


// *****************************************************************************

#slide(title: [#td])[

  #box(height: 500pt)[
    Las trayectorias del agente son *aleatorias*, por lo que se necesitan #stress[muchos datos] (experiencia, trayectorias, *retornos*...) para poder estimar correctamente las funciones de valor.

    #framed[ #emoji.quest ¿Cómo evitamos esperar al *final* de un episodio para obtener $G_t$?]

    #emoji.checkmark.box Utilizando una *estimación* de $G_t$.

    #framed[ #emoji.quest ¿Y qué es, por definición, "una estimación de $G_t$"?]

    #emoji.face.explode ¡La #stress[función de valor] $V tilde.eq v_pi$ que estamos aproximando!

    #h(2cm) $arrow.r.curve$ _Recordemos que $v_pi (s) = EE[G_t | S_t = s]$_.
  ]
]

// *****************************************************************************

#slide(title: [#td])[

  Es decir, para actualizar el valor de cada estado *no es necesario esperar al final del episodio* y emplear $G_t$ como objetivo.

  Podemos simplemente utilizar #stress[el valor del siguiente estado], que es por definición, una expectativa del retorno que podemos obtener.

  #align(center)[#image("images/updates.png", width: 60%)]

]
// *****************************************************************************

#slide(title: [#td])[
  #align(center)[#image("images/td-update.png", width: 90%)]
]

// *****************************************************************************

#slide(title: [#td])[

  - El #stress[valor] $v_pi (s)$ es el retorno $G_t$ esperado siguiendo $pi$ desde el estado $s$:

  #grayed[$ v_pi (s) = EE[G_t | S_t = s] $]

  - La definición de #stress[retorno] es:

  #grayed[
    $
      G_t &= R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + dots + gamma^(T-1) R_T \
      &= R_(t+1) + gamma (R_(t+2) + gamma R_(t+3) + dots + gamma^(T-2) R_T ) \
      &= R_(t+1) + gamma G_(t+1)
    $]

  Tenemos una *definición recursiva del retorno*.

]

// *****************************************************************************

#slide(title: [#td])[

  Vamos a introducir esta *definición recursiva* de retorno en la definición de $v_pi$.

  - Si las combinamos tenemos:

  #grayed[
    $
      v_pi (s) &= EE [colmath(G_t, color:#orange) | S_t = s] \
      &= EE [colmath(R_(t+1), color:#blue) + colmath(gamma G_(t+1)) | S_t = s] \
      &= EE [colmath(R_(t+1), color:#blue) + colmath(gamma v_pi (S_(t+1)), color:#olive) | S_t = s]
    $]

  Es decir, el #stress[retorno esperado, $G_t$,] es igual a la suma de la #text(fill:blue)[*recompensa inmediata*, $R_(t+1)$,] y el #text(fill:red)[*retorno descontado futuro*, $gamma G_(t+1)$].

  Por definición, este es igual a #text(fill:olive)[*la función de valor descontada del siguiente estado*, $gamma v_pi (S_(t+1))$].

]

// *****************************************************************************

#slide(title: [#td])[

  Esto significa que #stress[podemos estimar la función de valor $v_pi (s)$ en cada _time step_].

  Dado una experiencia $S_t, A_t, R_(t+1), S_(t+1) tilde.op pi$, la estimación $V(S_t)$ se actualiza de la siguiente forma:

  #grayed[$ V_(t+1) (S_t) = V_t (S_t) + alpha [R_(t+1) + gamma V_t (S_(t+1)) - V_t (S_t)] $]

  #grayed[$ V (S_t) <- V (S_t) + alpha [R_(t+1) + gamma V (S_(t+1)) - V (S_t)] $]

  Este método se denomina #stress[TD(0)] o #stress[_one-step TD_], porque únicamente tiene en cuenta el _time step_ inmediatamente posterior.

]


// *****************************************************************************

#slide(title: [#td])[

  #let a = text(fill: olive)[Valor\ estimado\ actual]
  #let b = text(fill: blue)[_TD-target_]
  #let c = text(fill: red)[_TD-error_]

  #grayed[
    $
      V (S_t) <- underbrace(V (S_t), bold(#a)) + alpha [overbrace(underbrace(colmath(R_(t+1) + gamma V (S_(t+1)), color:#blue), bold(#b)) - V (S_t), bold(#c))]
    $
  ]
]
