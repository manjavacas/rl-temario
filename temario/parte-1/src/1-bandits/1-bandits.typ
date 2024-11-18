#import "@preview/typslides:1.2.0": *

#show: typslides.with(
  ratio: "16-9",
  theme: "reddy",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)

#let colmath(x, color) = text(fill: color)[#x]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: [_Bandits_],
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents()

// *****************************************************************************

#slide(title: "Motivación")[

  - Ya conocemos las diferencias entre aprendizaje #stress[instructivo] y #stress[evaluativo].

  - También hemos visto que el aprendizaje #stress[evaluativo] es la base del #stress[aprendizaje por refuerzo] (RL).

  #v(1cm)

  #framed[
    *OBJETIVO*: profundizar sobre RL en un #stress[entorno simplificado], en el cual no es necesario aprender a actuar en más de una situación.

    - Una simplificación de los problemas de _reinforcement learning_ "completos".
    - Esto nos permitirá introducir algunos conceptos básicos.
  ]
]

// *****************************************************************************

#title-slide([_Bandits_])

// *****************************************************************************

#slide(title: "Entornos no asociativos")[

  #v(.5cm)

  - Los problemas de RL pueden entenderse como problemas de #stress[toma de decisiones].
    - Un agente recibe información del entorno y *decide* qué acción realizar.

  - En un problema de RL *completo*, consideramos múltiples estados, así como diferentes acciones a realizar dependiendo de qué estado perciba el agente.
    - Las acciones pueden afectar el estado del entorno y, por tanto, influir en las recompensas futuras.

  - Antes de abordar problemas de RL complejos, estudiaremos un #stress[problema simplificado] donde el concepto de _estado_ no es tan relevante, y únicamente se tienen en cuenta las _acciones_ a realizar por el agente.
    - Es lo que llamos un #stress[entorno no asociativo].
]

// *****************************************************************************

#slide(title: [_Bandits_])[
  #figure(image("images/rl-bandits.png", width: 100%))
]

// *****************************************************************************

#slide(title: [El problema de los _K-armed bandits_])[
  #columns(2)[
    - #stress[*_K-armed bandits_*], también llamado #stress[_multi-armed bandit problem_]
      - #text(size: 12pt)["problema de las _tragaperras multi-brazo_" (#emoji.face.inv)]

    - Problema clásico en RL y teoría de la probabilidad.

    - Extrapolable a campos tan variados como ensayos clínicos, gestión empresarial, economía, _marketing_...

    - Existen muchas variantes, pero nos centraremos en la versión más básica del problema.

    #colbreak()

    #v(1.5cm)
    #figure(image("images/bandit.png", width: 60%), caption: [_Armed bandit_])
  ]
]

// *****************************************************************************

#slide(title: [El problema de los _K-armed bandits_])[
  #columns(2)[

    #v(1.5cm)

    #figure(image("images/bandits.png", width: 100%), caption: [_K-armed bandits_])

    Tenemos un número arbitrario ($K$) de máquinas tragaperras.

    #colbreak()

    - En cada instante de tiempo $t$, accionamos una máquina y recibimos una recompensa (#emoji.money.wings).

    - Cada máquina puede comportarse de forma diferente.

    - Desconocemos la *distribución de recompensas* de cada máquina.

    #framed[
      #stress[*OBJETIVO*]: obtener la mayor recompensa posible (*recompensa acumulada*).
    ]
  ]
]

// *****************************************************************************

#slide(title: [El problema de los _K-armed bandits_])[

  #columns(2)[
    #figure(image("images/bandits_3.png", width: 90%), caption: [_3-armed bandits_])

    #align(center)[
      #framed[
        $b_1$ : $mu = 10, sigma = 2$

        $b_2$ : $mu = 10, sigma = 4$

        $b_3$ : $mu = 7, sigma = 2$
      ]
      #text(size: 13pt)[_Distribuciones de recompensas_: medias y desviaciones típicas]
    ]

    #colbreak()

    #align(center)[#image("images/distribs.png")]
  ]
]

// *****************************************************************************

#slide(title: [El problema de los _K-armed bandits_])[

  #columns(2)[

    #set text(size: 18pt)

    #v(-.5cm)

    #framed[
      Buscamos maximizar la #stress[recompensa acumulada] concentrando nuestras acciones en las mejores acciones.
    ]

    - Las recompensas medias de $b_1$ y $b_2$ son similares. No obstante, $b_2$ es más conservador (menor $sigma ->$ valores más próximos a la media).

    - Jugar $b_2$ es más arriesgado (mayor $sigma$), porque puede darnos mejores recompensas que $b_2$ y $b_3$, pero también recompensas mucho peores.

    - Jugar $b_3$ no parece una buena idea...

    #colbreak()

    #figure(image("images/distribs.png"))
  ]
]

// *****************************************************************************

#slide(title: [El problema de los _K-armed bandits_])[

  #columns(2)[

    #figure(image("images/distribs.png", width: 60%))

    #align(center)[
      #stress[*Espacio de acciones*]:
      $cal(A) = {a_1, a_2, a_3}$
    ]

    #colbreak()

    #v(1cm)

    #figure(image("images/bandit_loop.png"))

  ]
]


// *****************************************************************************

#slide(title: [El problema de los _K-armed bandits_])[

  #columns(2)[

    #figure(image("images/distribs.png", width: 60%))

    #align(center)[
      #stress[*Espacio de acciones*]:
      $cal(A) = {a_1, a_2, a_3}$
    ]

    #colbreak()

    #figure(image("images/bandit_loop_3.png"))

  ]
]

// *****************************************************************************

#slide(title: "Valor de una acción")[

  El #stress[*valor de una acción*] (_action-value_) es la recompensa que esperamos obtener al realizarla:

  // #alternatives-match((
  //       "1" : [
  //         $ q_*(a) = EE[R_t | A_t = a] $
  //         #v(7cm)
  //       ],
  //       "2" : [
  //         $ underbracket(q_*(a), "Valor de\nla acción") = underbracket(EE[R_t | A_t = a], "Recompensa esperada\nal realizar dicha acción") $
  //       ]
  //
  #v(-.5cm)

  #text(size: 27pt)[
    $
      underbracket(q_*(a), "Valor de\nla acción") = underbracket(EE[R_t | A_t = a], "Recompensa esperada\nal realizar dicha acción")
    $
  ]

  #v(.3cm)

  #align(center)[
    #framed[
      $EE$ representa el *valor esperado*:
      #align(center)[$EE(x) = sum x #h(.1cm) P(X=x)$]
    ]
  ]

  #v(.2cm)

  #text(size: 20pt)[
    - Suma ponderada de los posibles valores de $x$ por sus probabilidades.
    - Relevante en #stress[problemas estocásticos] donde $R_t$ viene dada por una distribución de probabilidad.
  ]
]

// *****************************************************************************

#slide(title: "Problemas deteministas y estocásticos")[

  #columns(2)[

    #set text(size: 18pt)

    #framed(title: "Problema determinista")[
      Toda acción $a in cal(A)$ siempre tiene las mismas consecuencias.
    ]

    #framed(title: "Problema estocástico")[
      Realizar una acción $a in cal(A)$ puede conducirnos a diferentes recompensas o estados a partir de situaciones similares.
    ]

    #colbreak()

    #v(.5cm)

    #figure(image("images/deterministic.png", width: 80%))

    #v(1cm)

    #figure(image("images/stochastic.png", width: 100%))

  ]
]

// *****************************************************************************

#slide(title: "Valor de una acción")[

  Si desarrollamos la fórmula:

  // #align(center)[
  //   #alternatives-match((
  //     "1": [
  //       $q_*(a) = EE[R_t | A_t = a] = sum_r r #v(1cm) p(r|a)$
  //     ],
  //     "2": [
  //       $q_*(a) = EE[
  //           R_t | A_t = a
  //         ] = colmath(underbracket(sum_r r #h(0.2cm) p(r|a), "Suma ponderada de\nlas recompensas por\n sus probabilidades"), #red)$
  //     ],
  //   ))
  // ]
  //
  #v(1cm)

  #align(center)[
    #text(size: 25pt)[
      $q_*(a) = EE[
          R_t | A_t = a
        ] = colmath(underbracket(sum_r r #h(0.2cm) p(r|a), "Suma ponderada de\nlas recompensas por\n sus probabilidades"), #blue)$
    ]
  ]

  #columns(2)[

    #figure(image("images/stochastic.png"))

    #colbreak()

    #v(2.5cm)

    $q_*(a) &= 0 dot 0.25 + 10 dot 0.25 + dot (-1) dot 0.5 \
      &= 0 + 2.5 - 0.5 = bold(2)$

  ]
]

// *****************************************************************************

#slide(title: "Valor de una acción")[

  #v(.5cm)

  Como, a priori, no conocemos los valores reales de cada acción, consideramos valores estimados:

  #text(size: 28pt)[$ Q_t (a) approx q_*(a) $]

  Estos valores se irán aproximando a los reales a medida que ampliemos nuestra *experiencia*.

  Pero...

  #v(.5cm)

  #align(center)[
    #framed[
      _¿Cómo aproximamos progresivamente los valores de las acciones?_
    ]
  ]
]

// *****************************************************************************

#title-slide[Exploración _vs._ Explotación]

// *****************************************************************************

#slide(title: [Exploración _vs._ Explotación])[

  #v(.5cm)

  #columns(2, gutter: 3cm)[

    Consideremos el siguiente caso:

    - Tenemos 3 _bandits_ y, por tanto, 3 posibles acciones.

    - Inicialmente, desconocemos el valor de cada acción:

    #h(3cm) $q_*(a) = 0, forall a in cal(A)$

    - Por tanto, comenzamos eligiendo una acción arbitraria.

      - Es decir, #stress[exploramos].

    #colbreak()

    #figure(image("images/exploration_1.png", width: 120%))
  ]
]

// *****************************************************************************

#slide(title: [Exploración _vs._ Explotación])[

  #columns(2, gutter: 2cm)[

    #set text(size: 19pt)

    - El agente elige $a_1$ y recibe una recompensa $r_1 = 1$.

    - Posteriormente, convendrá explorar $a_2$ y $a_3$ para comprobar si son mejores opciones.

    #framed[*Explorar* implica sacrificar recompensas inmediatas conocidas para probar alternativas hasta el momento no contempladas.]

    #text(size: 18pt)[
      Esta inversión podría llevarnos a obtener mayores recompensas _a largo plazo_.
    ]

    #colbreak()

    #figure(image("images/exploration_2.png", width: 120%))
  ]
]

// *****************************************************************************

#slide(title: [Exploración _vs._ Explotación])[

  - Es una idea similar a elegir entre un *restaurante* de confianza o uno que no has visitado nunca... #emoji.cutlery
  - ...o entre tu género de *películas* favorito y otro que no sueles ver... #emoji.camera.movie
  - ...o entre un *producto* que sueles comprar y otro que podría interesarte... #emoji.cart

  #v(.5cm)

  _¿Intuyes las posibles aplicaciones?_

  #v(1.5cm)

  #align(center)[
    #grid(
      columns: (200pt, 200pt),
      gutter: 0.25pt,
      image("images/netflix.png", width: 50%), image("images/amazon.png", width: 50%),
    )
  ]
]

// *****************************************************************************

#slide(title: [Exploración _vs._ Explotación])[

  #columns(2, gutter: 2cm)[

    #set text(size: 25pt)

    #v(5cm)

    - El agente elige $a_2$ y recibe\ una recompensa $r_2 = 10$.

    #colbreak()

    #figure(image("images/exploration_3.png", width: 120%))
  ]
]

// *****************************************************************************

#slide(title: [Exploración _vs._ Explotación])[

  #columns(2, gutter: 2cm)[

    #set text(size: 25pt)

    #v(5cm)

    - El agente elige $a_3$ y recibe\ una recompensa $r_3 = 5$.

    #colbreak()

    #figure(image("images/exploration_4.png", width: 120%))
  ]
]

// *****************************************************************************

#slide(title: [Exploración _vs._ Explotación])[

  #columns(2, gutter: 2cm)[

    - En $t=3$ hemos realizado todas las acciones posibles y recibidas sus correspondientes recompensas.

      A partir de aquí podemos:

      #text(size: 20pt)[
        *a.* Actuar de forma _*greedy*_ ("voraz"), #stress[*explotando*] indefinidamente la mejor acción ($a_2$).

        *b.* Mantener un comportamiento aleatorio, #stress[*explorando*] continuamente las distribuciones de recompensa asociadas a cada acción.
      ]


    #colbreak()

    #figure(image("images/exploration_4.png", width: 120%))

  ]
]

// *****************************************************************************

#slide(title: [Exploración _vs._ Explotación])[

  #columns(2)[

    #v(.5cm)

    #figure(image("images/tradeoff.png", width: 90%))

    #colbreak()

    #v(1cm)

    No es posible *explorar* y *explotar* a la vez, lo que conduce a un *conflicto*.

    - #stress[_Exploration-exploitation trade-off_]

    Elegir una estrategia u otra dependerá de diferentes factores: incertidumbre, estimaciones, tiempo restante...
  ]
  #framed[
    Trataremos de buscar un *balance* entre exploración y explotación, siguiendo un comportamiento #stress[$bold(epsilon)$-greedy].
  ]
]

// *****************************************************************************

#slide(title: [$bold(epsilon)$-greedy])[

  #columns(2, gutter: -.7cm)[

    #v(2cm)

    #set text(size: 23pt)

    La estrategia $epsilon$-_greedy_ consiste en combinar *exploración* y *explotación*:

    #v(0.5cm)

    - *Explotación* (elegir de forma _greedy_ la mejor acción) con probabilidad #stress[$bold(1 - epsilon)$].

    #v(0.2cm)

    - *Exploración* (elegir una acción aleatoriamente) con probabilidad #stress[$bold(epsilon)$].

    #colbreak()

    #v(2cm)

    #figure(image("images/balance.png", width: 60%))
  ]
]

// *****************************************************************************

#slide(title: [$bold(epsilon)$-greedy])[
  - Para poder actuar de forma _greedy_ necesitamos saber qué acción es la mejor.

  - Pero una acción puede no darnos siempre la misma recompensa...

  #figure(
    image("images/rewards_distrib.png", width: 50%),
  )

  #align(center)[#framed[¿Cómo determinamos el valor de una acción?]]
]

// *****************************************************************************

#title-slide([Estimación de _action--values_])

// *****************************************************************************

#slide(title: [Estimación de _action--values_])[

  Existen diferentes formas de estimar el valor de una acción.

  Un método a considerar es la #stress[media muestral] (_sample-average method_):

  #v(.8cm)

  #columns(2)[

    #set text(size: 25pt)
    #align(center)[
      #framed[
        #set text(size: 30pt)
        #v(1cm)
        $Q_t (a) = (sum_(i=1)^(t-1) R_(i,a)) / (sum_(i=1)^(t-1) n_(i,a))$
        #v(1cm)
      ]
    ]
    #v(0.2cm)
    #set text(size: 20pt)
    $ t -> infinity, #h(0.5cm) Q_t (a) = q_*(a) $

    #colbreak()

    #v(.5cm)

    - El valor estimado de una acción es la suma de las recompensas ofrecidas hasta el momento entre el número de veces que se ha elegido.

    - Si $t$ tiende a $infinity$, el valor estimado $Q_t (a)$ convergerá en el valor real $q_* (a)$.
  ]
]

// *****************************************************************************

#slide(title: [Acciones _greedy_])[

  #align(center)[#framed[¿Cómo emplear el valor estimado para elegir una acción?]]\

  Selección de acciones #stress[_greedy_]:

  #text(28pt)[$ A_t = op("argmax")_a Q_t (a) $]

  - Seleccionar la acción con el mayor valor estimado.

  - Si varias acciones tienen el mismo valor, podemos fijar un criterio (ej. selección aleatoria, la primera, etc.).
]

// *****************************************************************************

#slide(title: [Acciones $epsilon$-_greedy_])[

  #align(center)[#framed[¿Cómo emplear el valor estimado para elegir una acción?]]

  #v(.4cm)

  #stress[$epsilon$-_greedy_] combina la estrategia _greedy_ con la probabilidad $epsilon$ de explorar:

  #v(.3cm)

  #align(center)[
    #framed[
      #set text(28pt)
      #v(1cm)
      $A_t = cases(
        op("argmax")_a Q_t (a) text("                        con prob.") 1-epsilon\
        a ~ op("Uniform")({a_1, a_2, dots a_k})text("         con prob.") epsilon
      )$
      #v(1cm)
    ]
  ]

  - Cuanto menor sea $epsilon$, más tardaremos en converger en los valores reales.

  #text(size: 19pt)[
    - Es posible ir reduciendo $epsilon$ con el paso del tiempo (a medida que los valores convergen).
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  Consideremos el espacio de acciones: $cal(A) = {a_1, a_2}$

  #v(1cm)

  #framed[¿Cuál es la probabilidad de elegir $a_2$ siguiendo una estrategia $epsilon$-_greedy_ con $epsilon = 0.5$?]

  #let s = text[Probabilidad #linebreak() de que la acción #linebreak() elegida sea $a_2$]

  #v(1cm)
  #set text(28pt)

  $ P(a_2) = 0.5 dot 0.5 = bold(0.25) $

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  Consideremos el espacio de acciones: $cal(A) = {a_1, a_2}$

  #v(1cm)

  #framed[¿Cuál es la probabilidad de elegir $a_2$ siguiendo una estrategia $epsilon$-_greedy_ con $epsilon = 0.5$?]

  #let s = text[Probabilidad #linebreak() de que la acción #linebreak() elegida sea $a_2$]

  #v(1cm)
  #set text(28pt)

  $
    P(
      a_2
    ) = underbracket(colmath(bold(0.5), #blue), "Probabilidad\nde explorar") dot underbracket(colmath(bold(0.5), #blue), #s) = 0.25
  $
]

// *****************************************************************************

#slide(title: "¿Qué método elegir?")[

  #v(1cm)

  Podemos asumir que la elección de un método u otro se realizará cuando todas las acciones hayan sido probadas, al menos, una vez.

  - Si las recompensas son #stress[valores únicos] ($sigma = 0$), elegiremos siempre la acción con mejores resultados.
    - En este caso, *_greedy_* es mejor.

  - Si las recompensas se corresponden con una #stress[distribución de probabilidad] ($sigma > 0$), nos interesa no perder la posibilidad de explorar.
    - Por tanto, es mejor $bold(epsilon)$*-_greedy_*.
    - Especialmente en problemas con _noisier rewards_ $->$ mayor varianza de las distribuciones.
]

// *****************************************************************************

#slide(title: "No estacionareidad")[

  #v(-1cm)

  #set text(size: 18pt)
  #framed(title: "Problema no estacionario")[
    Decimos que un problema de decisión es #stress[no estacionario] si las distribuciones de recompensa varían con el tiempo.
  ]

  #columns(2)[

    #figure(image("images/stationarity.png", width: 90%))

    #colbreak()

    #set text(18pt)

    - Una acción, _a priori_, mala puede mejorar con el tiempo, y viceversa.

    - Es un fenómeno muy común en aprendizaje por refuerzo.

    En este tipo de problemas, la mejor estrategia es $epsilon$-_greedy_, porque nunca se descarta la posibilidad de explorar y, por tanto, de #stress[reaprender las distribuciones de recompensa].
  ]
]

// *****************************************************************************

#title-slide([_Action-values_: cálculo incremental])

// *****************************************************************************

#slide(title: "Valor estimado de una acción")[

  Previamente hemos propuesto estimar el valor de las acciones de la siguiente forma:

  #text(28pt)[$ Q_t (a) = (sum_(i=1)^(t-1) R_(i,a)) / (sum_(i=1)^(t-1) n_(i,a)) $]

  El problema de este cálculo es que requiere mantener en *memoria* todas las recompensas obtenidas para cada acción en el tiempo.

  - En problemas con un gran espacio de acciones, o prolongados en el tiempo, este método es inviable en términos de escalabilidad.

  *SOLUCIÓN*: #stress[cálculo incremental de la media].
]

// *****************************************************************************

#slide(title: text(28pt)[Cálculo incremental del _action-value_])[

  #columns(2)[

    #v(2cm)

    Si desarrollamos la fórmula para el cálculo del _action-value_ medio, podemos hacer que este cálculo sea *incremental*.

    #v(.6cm)

    #framed[
      No depende de todas las recompensas anteriores, sino únicamente del *_action-value_ actual* y de la *última recompensa* obtenida.
    ]

    #colbreak()

    $
      Q_(n+1) &= colmath(1/n sum_(i=1)^n R_i, #blue) \
      &= 1 / n (R_n + sum_(i=1)^(n-1) R_i) \
      &= 1 / n (R_n + (n-1) 1 / (n-1) sum_(i=1)^(n-1) R_i) \
      &= 1 / n (R_n + (n-1) Q_n) \
      &= 1 / n (R_n + n Q_n - Q_n) \
      &= colmath(Q_n + 1/n (R_n - Q_n), #blue)
    $
  ]
]

// *****************************************************************************

#slide(title: [Cálculo incremental del _action-value_])[

  #v(.5cm)

  #text(24pt)[
    $ Q_(n+1) = 1 / n sum_(i=1)^n R_i = Q_n + 1 / n (R_n - Q_n) $
  ]

  Se trata de una regla de actualización incremental (#stress[_incremental update rule_]) bastante frecuente en RL:

  #v(.4cm)

  #align(center)[
    #framed[
      $op("nuevoValor") <- op("valorActual") + op("stepSize") (op("objetivo") - op("valorActual"))$
    ]
  ]

  #v(.3cm)
  O bien:

  #set text(28pt)
  $ v_(t) <- v_t + alpha[G_t - v_t], #h(0.3cm) alpha in \(0,1\] $

]

// *****************************************************************************

#slide(title: [Cálculo incremental del _action-value_])[

  #let a = $frac(1,N(A))$

  #text(26pt)[
    $
      Q(A) <- Q(
        A
      ) + underbracket(#a, "step\nsize") dot underbracket([underbracket(R, "objetivo") - underbracket(Q(A), "estimación\nactual")], "error de estimación")
    $
  ]

  #v(.5cm)

  - El #stress[error de estimación] se reduce a medida que las #stress[estimaciones] se acercan al #stress[objetivo].

  - Indica la diferencia entre la recompensa obtenida y el valor actual.
    - Determina cuánto nos hemos equivocado en nuestra estimación más reciente.
]

// *****************************************************************************

#slide(title: [Cálculo incremental del _action-value_])[

  #v(.4cm)

  #let a = $frac(1,N(A))$

  #text(26pt)[
    $
      Q(A) <- Q(
        A
      ) + underbracket(#a, "step\nsize") dot underbracket([underbracket(R, "objetivo") - underbracket(Q(A), "estimación\nactual")], "error de estimación")
    $
  ]

  #v(.1cm)

  - El #stress[_step-size_] pondera la importancia que damos al error de estimación.
    - Determina el peso de la nueva información recibida.

  - Lo que hacemos es añadir un pequeño ajuste al valor anterior de la acción, que depende de la diferencia entre la recompensa obtenida y nuestra estimación anterior del valor de la acción.
]

// *****************************************************************************

#focus-slide("Un ejemplo...")

// *****************************************************************************

#slide(title: "Ejemplo: piedra, papel, tijeras")[

  #align(center)[
    R = $+1$ si se gana #h(1cm) R = $0$ si se pierde o empata #h(1cm) $alpha = 1/N$
    #table(
      columns: (auto, auto, auto, auto, auto, auto),
      inset: 9.7pt,
      align: center,
      fill: (x, y) => if y == 0 {
        silver
      },
      table.header(
        [*t*],
        [*Yo*],
        [*Rival*],
        [*Recompensa*],
        [*Actualización*],
        [$bold(Q(op("tijeras")))$],
      ),

      [0], [-], [-], [-], [-], [0],
      [1], [#emoji.scissors], [#emoji.rock], [0], [$Q(op("tijeras")) = 0 + 1 (0 - 0)$], [0],
      [2], [#emoji.scissors], [#emoji.page], [+1], [$Q(op("tijeras")) = 0 + 1 / 2 (1 - 0)$], [0.1],
      [3], [#emoji.scissors], [#emoji.rock], [0], [$Q(op("tijeras")) = 0.5 + 1 / 3 (0 - 0.5)$], [0.09],
      [4], [#emoji.scissors], [#emoji.scissors], [0], [$Q(op("tijeras")) = 0.335 + 1 / 4 (0-0.335)$], [0.081],
      [$dots$], [$dots$], [$dots$], [$dots$], [$dots$], [$dots$],
      [N-1], [-], [-], [-], [-], [0.33],
    )
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo: piedra, papel, tijeras")[

  #align(center)[
    ¿Y si variamos el _step size_? #h(1cm) $alpha = 0.1$
    #table(
      columns: (auto, auto, auto, auto, auto, auto),
      inset: 9.7pt,
      align: center,
      fill: (x, y) => if y == 0 {
        silver
      },
      table.header(
        [*t*],
        [*Yo*],
        [*Rival*],
        [*Recompensa*],
        [*Actualización*],
        [$bold(Q(op("tijeras")))$],
      ),

      [0], [-], [-], [-], [-], [0],
      [1], [#emoji.scissors], [#emoji.rock], [0], [$Q(op("tijeras")) = 0 + bold(0.1) (0 - 0)$], [0],
      [2], [#emoji.scissors], [#emoji.page], [+1], [$Q(op("tijeras")) = 0 + bold(0.1) (1 - 0)$], [0.5],
      [3], [#emoji.scissors], [#emoji.rock], [0], [$Q(op("tijeras")) = 0.5 + bold(0.1) (0 - 0.5)$], [0.335],
      [4], [#emoji.scissors], [#emoji.scissors], [0], [$Q(op("tijeras")) = 0.335 + bold(0.1) (0-0.335)$], [0.25125],
      [$dots$], [$dots$], [$dots$], [$dots$], [$dots$], [$dots$],
      [N-1], [-], [-], [-], [-], [0.33],
    )
  ]

]

// *****************************************************************************

#let m = text[Elección del _step size_]

#slide(title: [#m])[

  #v(.4cm)

  La principal diferencia entre _step sizes_ es la *velocidad de convergencia*:

  #v(.5cm)

  - $alpha = 1/N$ supone una convergencia más lenta a medida que aumenta $N$. Esto provoca que actualizaciones más pequeñas y menos impactantes con el paso del tiempo.

  #v(.1cm)

  #align(center)[#framed[Deseable si queremos dar más peso a las experiencias tempranas.]]

  #v(.5cm)

  - Si se utiliza un _step size_ constante, $alpha in (0,1]$, la estimación del _action-value_ converge más rápido hacia su valor real, pero es más sensible a experiencias recientes.

  #align(center)[#framed[Más efectivo cuando se desea dar más peso a las experiencias recientes.]]

]

// *****************************************************************************

#slide(title: [Elección del _step size_])[

  #columns(2)[

    - En #stress[problemas estacionarios], los métodos basados en media muestral (_average sampling_) son apropiados, porque las distribuciones de probabilidad de las recompensas no varían con el tiempo.

      - Es decir, preferimos $alpha = 1/N$

    - En #stress[problemas no estacionarios], es más importante dar mayor peso a las recompensas recientes.

      - Por tanto, optamos por $alpha in \(0,1\]$

    #colbreak()

    #figure(image("images/stationary.png", width: 20%))
    #figure(image("images/stationarity.png", width: 60%))

  ]
]

// *****************************************************************************

#slide(title: [Elección del _step size_])[

  #align(center)[#image("images/comparison.png", width: 90%)]

]

// *****************************************************************************

// *****************************************************************************

#title-slide("Valores iniciales")

// *****************************************************************************

#slide(title: "Valores iniciales optimistas")[

  #columns(2)[

    Los métodos que hemos visto dependen en gran medida de las estimaciones iniciales de los _action-values_.

    Esto supone un #stress[sesgo] (_bias_).

    - En el método de la *media muestral*, si inicialmente todas las acciones tienen valor 0, habrá un sesgo hacia la primera acción de la que se obtenga una recompensa > 0.

    - *El sesgo desaparece una vez hemos seleccionado todas las acciones posibles*.

    #colbreak()

    #v(1cm)

    #figure(image("images/bias.png", width: 100%))

  ]

]

// *****************************************************************************

// #slide(title: "Valores iniciales optimistas")[

//   #let l = text("A mayor número de\nexperiencias pasadas (n)\nmenor peso tienen las\nrecompensas anteriores")

//   En métodos con #stress[_step size_ constante], el sesgo es permanente, aunque decrece con el tiempo:

//   #align(center)[
//     #alternatives-match((
//       "1": [
//         $
//           Q_(n+1) &= Q_n + alpha[R_n - Q_n] \
//           &= (1-alpha)^n Q_1 + sum_(i=1)^n alpha(1 - alpha)^(n-i) R_i
//         $
//         #v(2.5cm)
//       ],
//       "2": [
//         $
//           Q_(n+1) &= Q_n + alpha[R_n - Q_n] \
//           &= (1-alpha)^n Q_1 + colmath(underbracket(sum_(i=1)^n alpha(1 - alpha)^(n-i) R_i, #l), #red)
//         $
//       ],
//     ))
//   ]
// ]
//

#slide(title: "Valores iniciales optimistas")[

  #let l = text("A mayor número de\nexperiencias pasadas (n)\nmenor peso tienen las\nrecompensas anteriores")

  #v(1cm)

  En métodos con #stress[_step size_ constante], el sesgo es permanente, aunque decrece con el tiempo:

  #set text(24pt)
  $
    Q_(n+1) &= Q_n + alpha[R_n - Q_n] \
    &= (1-alpha)^n Q_1 + sum_(i=1)^n alpha(1 - alpha)^(n-i) R_i
  $

]

// *****************************************************************************

#slide(title: "Valores iniciales optimistas")[

  #let l = text("A mayor número de\nexperiencias pasadas (n)\nmenor peso tienen las\nrecompensas anteriores")

  #v(1cm)

  En métodos con #stress[_step size_ constante], el sesgo es permanente, aunque decrece con el tiempo:

  #set text(24pt)
  $
    Q_(n+1) &= Q_n + alpha[R_n - Q_n] \
    &= (1-alpha)^n Q_1 + colmath(underbracket(sum_(i=1)^n alpha(1 - alpha)^(n-i) R_i, #l), #blue)
  $

]

// *****************************************************************************

#slide(title: "Valores iniciales optimistas")[

  #v(3.5cm)

  En la práctica, el sesgo no suele ser un problema y a veces puede resultar muy útil.

  - Las estimaciones inciales pueden proporcionar #stress[conocimiento previo/experto] sobre qué recompensas podemos esperar de cada acción.

  - Un inconveniente es que estas estimaciones iniciales se convierten en un #stress[conjunto de parámetros que el usuario debe elegir], aunque por defecto pueden ser = 0.
]

// *****************************************************************************

#slide(title: "Sesgo como apoyo a la exploración")[

  Podemos utilizar el sesgo para guitar la exploración inicial de nuestro agente.\ Por ejemplo:

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1pt,
    grid.cell(
      figure(image("images/bias-1.png", width: 85%)),
    ),
    grid.cell(
      figure(image("images/bias-2.png", width: 81%)),
    ),
    grid.cell(
      figure(image("images/bias-3.png", width: 85%)),
    ),
    grid.cell(
      text(size: 15pt)[
        #framed[
          Se asignan falsos valores iniciales (+100) a cada acción, a pesar de que los valores reales estén en el intervalo [-2, +2].
        ]
      ],
    ),
    grid.cell(
      text(size: 14pt)[
        #framed[
          Se elige una acción en base a su valor estimado inicial. Podría ser la mejor, pero sigue siendo peor que los valores iniciales del resto de acciones.
        ]
      ],
    ),
    grid.cell(
      text(size: 15pt)[
        #framed[
          De esta forma, se aprovecha el sesgo para favorecer naturalmente la *exploración* inicial de todas las acciones posibles.
        ]
      ],
    )
  )
]

// *****************************************************************************

#slide(title: "Sesgo como apoyo a la exploración")[

  #text(size: 19pt)[
    Utilizamos el sesgo para provocar la exploración inicial de todas/algunas acciones.

    #stress[*Esto permite que incluso un método _greedy_ explore*].

    - Se denomina #stress[_optimistic greedy_], porque emplea valores iniciales optimistas.
      - Puede dar lugar a mejores resultados que un $epsilon$-_greedy_ estándar.

    - La principal limitación es que la exploración es simplemente inicial (disminuye con el tiempo hasta desaparecer).
      - Esto hace que no sea útil en problemas *no estacionarios*.

    #v(.5cm)

    #framed[
      #text(size: 18pt)[
        "_The beginning of time occurs only once, and thus we should not focus on it too much_".
      ]
      #align(right)[
        #text(size: 13pt)[
          #emoji.books _Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction (2nd ed.). MIT press. (p. 35)._]
      ]
    ]
  ]
]

// *****************************************************************************

#title-slide([_Upper-confidence-bound_])

// *****************************************************************************

#slide(title: [Exploración $epsilon$-_greedy_])[

  #v(1cm)

  $epsilon$-_greedy_ fuerza la seleccion de acciones _non-greedy_ de forma indiscriminada:

  #text(23pt)[
    $
      A_t = cases(
      op("argmax")_a Q_t (a) text("                        con prob.") 1-epsilon\
      colmath(a ~ op("Uniform")({a_1, a_2, dots a_k})text("        con prob.") epsilon, #red)
    )
    $
  ]

  - Todas tienen la misma probabilidad.

  - No hay preferencia por aquellas más cercanas al valor _greedy_, o aquellas menos visitadas/desconocidas.

  Sería interesante explorar acciones *_non-greedy_* de acuerdo a su *potencial* para ser óptimas.

]

// *****************************************************************************

#slide(title: [_Upper-confidence-bound_])[

  #columns(2)[

    #text(size: 20.5pt)[

      #v(2cm)

      Para decidir qué acción explorar, podemos considerar:

      #v(.4cm)


      *A)* La cercanía al #stress[valor máximo actual]
      - #text(size: 19pt)[El valor de la acción _greedy_]

      *B)* La #stress[incertidumbre] en las estimaciones.
      - #text(size: 19pt)[Qué acciones se han realizado menos ($n_i$)]
    ]

    #colbreak()

    #figure(image("images/exp-e-greedy.png"))

  ]

]

// *****************************************************************************

#focus-slide("Si los combinamos...")

// *****************************************************************************

// #slide(title: [_Upper-confidence-bound_])[

//   La técnica del #stress[límite superior de confianza], o _Upper-confidence-bound_ (#stress[*UCB*]), nos permite balancear *valor* e *incertidumbre* a la hora de seleccionar acciones:

//   #alternatives-match((
//     "1": [
//       #align(center)[
//         $ A_t = op("argmax")_a [Q_t (a) + c #h(0.2cm) sqrt((ln t) / (N_t (a)))] $
//       ]
//       #v(2cm)
//     ],
//     "2": [
//       #v(0.5cm)
//       #align(center)[
//         $ A_t = op("argmax")_a [Q_t (a) + colmath(c, #blue) #h(0.2cm) colmath(sqrt((ln t) / (N_t (a))), #red)] $
//       ]
//       #v(1cm)
//       - $colmath(c>0, #blue)$ controla cuánto explorar.
//       - $colmath(N_t (a), #red)$ indica el número de seleccione sprevias de la acción $a$.
//         - Si $N_t (a) = 0$, se considera $a$ como la acción más preferible
//     ],
//   ))

// ]

#slide(title: [_Upper-confidence-bound_])[

  #v(1cm)

  El método del #stress[límite superior de confianza], o _Upper-confidence-bound_ (#stress[*UCB*]), nos permite balancear *valor* e *incertidumbre* a la hora de seleccionar acciones:

  $ A_t = op("argmax")_a [Q_t (a) + c #h(0.2cm) sqrt((ln t) / (N_t (a)))] $

]

// *****************************************************************************

#slide(title: [_Upper-confidence-bound_])[

  #v(1cm)

  El método del #stress[límite superior de confianza], o _Upper-confidence-bound_ (#stress[*UCB*]), nos permite balancear *valor* e *incertidumbre* a la hora de seleccionar acciones:

  $ A_t = op("argmax")_a [Q_t (a) + colmath(c, #blue) #h(0.2cm) colmath(sqrt((ln t) / (N_t (a))), #red)] $

  - $colmath(c>0, #blue)$ controla cuánto explorar.
  - $colmath(N_t (a), #red)$ indica el número de seleccione sprevias de la acción $a$.
    - Si $N_t (a) = 0$, se considera $a$ como la acción más preferible

]

// *****************************************************************************

#slide(title: [_Upper-confidence-bound_])[

  #text(size: 19pt)[

    $
      A_t = op("argmax")_a [
        colmath(underbracket(Q_t (a), "valor\nestimado"), #blue) + colmath(underbracket(c sqrt((ln t) / (N_t (a))), "incertidumbre"), #red)
      ]
    $

    La selección de una acción depende de:

    1. Su #text(fill:blue)[valor estimado] hasta el momento.
    2. La #text(fill:red)[incertidumbre] sobre dicha acción.
      - Cada vez que una acción se selecciona, su incertidumbre se reduce.
      - Según pasa el tiempo, la incertidumbre sobre una acción vuelve a aumentar poco a poco.

    El coeficiente $c$ pondera la importancia que damos a la exploración.

    UCB reduce la exploración con el tiempo (el término de incertidumbre tiende a 0).
  ]
]

// *****************************************************************************

#slide(title: "Incertidumbre en las estimaciones")[

  #v(.4cm)

  Definimos #stress[intervalos de confianza] dentro de los cuales se encuentran los valores originales de las acciones y, por tanto, sus estimaciones:

  #figure(image("images/ucb-1.png", width: 55%))
]

// *****************************************************************************

#slide(title: "Incertidumbre en las estimaciones")[

  #columns(2)[

    *Opción 1*. Elegir la acción con mayor incertidumbre (*exploración*).
    - A mayor incertidumbre, mayor creencia de que es bueno (_optimismo en presencia de incertidumbre_).
    - Elegimos la acción $colmath(a_1, #blue)$ en base a $ c sqrt((ln t)/(N_t (a))) $

    *Opción 2*. Elegir la acción con mayor valor estimado (*explotación*).
    - Elegimos la acción $colmath(a_2, #red)$ en base a $Q_t (a)$.

    #colbreak()
    #v(2.5cm)

    #figure(image("images/ucb-2.png"))

  ]
]

// *****************************************************************************

#title-slide("Trabajo propuesto")

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  #text(size: 18pt)[

    - *Implementación* y *comparativa* de los métodos _greedy_, $epsilon$-_greedy_ y UCB para un problema formalizado como $K$-armed bandits.

    - *_Thompson sampling_*
      - Definición y características.
      - Diferencias y similitudes con los métodos vistos.

    - *_Contextual bandits_*
      - ¿Qué son?
      - ¿Que relación podrían tener con las próximas lecciones?

    #text(25pt)[*Recursos interesantes*]

    - https://www.ma.imperial.ac.uk/~cpikebur/trybandits/trybandits.html
    - https://rlplaygrounds.com/reinforcement/learning/Bandits.html
    - https://youtu.be/bkw6hWvh_3k
  ]
]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: [_Bandits_],
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)