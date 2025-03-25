#import "@preview/typslides:1.2.5": *

#show: typslides.with(
  ratio: "16-9",
  theme: "dusky",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)

#let colmath(x, color: red) = text(fill: color)[$#x$]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Programación dinámica",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents(title: "Contenidos")

// *****************************************************************************

#title-slide([Programación dinámica])

// *****************************************************************************

#slide(title: "Programación dinámica")[

  La #stress[programación dinámica] (_dynamic programming_, *DP*) comprende un conjunto de algoritmos empleados para resolver problemas complejos dividiéndolos en subproblemas más pequeños.

  #figure(image("images/bellman.png"))

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #figure(image("images/cities-1.png"))

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #figure(image("images/cities-2.png"))

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #figure(image("images/cities-3.png"))

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #figure(image("images/cities-4.png"))

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #figure(image("images/cities-5.png"))

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #figure(image("images/cities-6.png"))

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #cols[
    #figure(image("images/subproblems.png"))
  ][
    Estamos descomponiendo un problema complejo en varios #stress[subproblemas] más sencillos.

    La #stress[solución óptima general] es igual a la #stress[composición de las soluciones óptimas] a los diferentes subproblemas.

    _Si en cada decisión elegimos la acción óptima, el resultado final será el óptimo._

    #figure(image("images/optimality.png"))
  ]
]

// *****************************************************************************

#slide(title: "Programación dinámica")[

  #framed[La programación dinámica permite el cálculo de políticas óptimas a partir de un MDP.]


  #emoji.thumb.down Son algoritmos #stress[poco eficientes] en la práctica, especialmente cuando el número de estados y/o acciones es elevado.


  #emoji.thumb.up No obstante, ofrecen una importante #stress[base teórica].


  - Más adelante estudiaremos otros algoritmos que tratan de imitar a la programación dinámica con menor coste computacional y sin asumir un modelo perfecto del entorno.

]

// *****************************************************************************

#slide(title: "Programación dinámica")[

  Emplearemos las #stress[funciones de valor] ($v$, $q$) para emprender la búsqueda de políticas óptimas

  - Recordemos las #stress[ecuaciones de optimalidad de Bellman]:

  #grayed[
    #set text(size: 24pt)
    $v^* (s) &= op(max)_a EE [R_(t+1) + gamma v^* (S_(t+1)) | S_t = S, A_t = a] \
      &= op(max)_a sum_(s',r) p(s',r|s, a)[r + gamma v^*(s')]$
  ]

  #grayed[
    #set text(size: 24pt)
    $q^*(s,a) &= EE[R_(t+1) + gamma op(max)_a' q^*(S_(t+1)) | S_t = s, A_t = a] \
      &= sum_(s',r)p(s',r|s,a)[r + gamma op(max)_a' q^*(s',a')]$
  ]

]

// *****************************************************************************

#slide(title: [Predicción _vs._ control])[

  Dividiremos los algoritmos a estudiar en dos categorías:


  #framed(title: "Predicción")[
    Obtener la función de valor ($v$, $q$) a partir de una política dada.
    \ #emoji.arrow.r #stress[_Evaluación de la política_].
  ]

  #framed(title: "Control")[
    Encontrar una política que maximice la recompensa acumulada.
    \ #emoji.arrow.r #stress[_Mejora de la política._]
  ]

  #emoji.checkmark.box El *control* es el principal objetivo en RL.
]

// *****************************************************************************

#title-slide("Iteración de la polítca")

// *****************************************************************************

#slide(title: "Iteración de la política")[

  #stress[Iteración de la política] (_policy iteration_) es un método empleado para aproximar progresivamente la política óptima en un MDP.

  - Consiste en la alternancia *evaluación* y *mejora* de la política:


  #framed[

    #emoji.chart.bar #stress[Evaluación de la política] (_policy evaluation_). Obtención de la función de valor $v_pi$ asociada a la política actual $-->$ *predicción*.


    #emoji.chart.up #stress[Mejora de la política] (_policy improvement_). Obtención de la política _greedy_ correspondiente a $v_pi$ $-->$ *control*.

  ]
]

// *****************************************************************************

#let eval = text[#emoji.chart.bar Evaluación de la política -- predicción]
#let impr = text[#emoji.chart.up Mejora de la política -- control]

#focus-slide(text-size: 40pt)[#emoji.chart.bar Evaluación de la política\ #text(size:25pt)[_Policy evaluation_]]

// *****************************************************************************

#slide(title: [#eval])[

  #framed(title: "Objetivo")[Calcular la función estado-valor $v_pi$ a partir de una política arbitraria $pi$.]

  - Recordemos que calcular $v_pi$ para cada estado puede ser computacionalmente costoso (incluso inviable).

  - Es por esto por lo que empleamos *métodos iterativos* que nos permitan aproximar estos valores:

  #grayed[$ v_0 --> v_1 --> v_2 --> dots --> v_pi $]
]

// *****************************************************************************

#slide(title: [#eval])[


  *¿CÓMO EVALUAR UNA POLÍTICA?*

  1. Los valores iniciales ($v_0$) se asignan de forma arbitraria, excepto para los estados terminales, con valor $= 0$.

  2. Consideramos una secuencia de funciones de valor aproximadas: $v_0, v_1, v_2, dots$, donde cada una establece un mapeo $cal(S)^+ -> RR$.

  3. Cada aproximación sucesiva se obtiene empleando la ecuación de Bellman para $v_pi$ como una #stress[regla de actualización], esto es:

  #grayed[
    $v_(k+1) (S_t) &= EE_pi [R_(t+1) + gamma v_k (S_(t+1)) | S_t = s] \
      &= sum_a pi(a|s) sum_(s',r) p(s',r|s,a) [r + gamma v_k (s')]$
  ]

]

// *****************************************************************************

#slide(title: [#eval])[

  - La actualización alcanza un *punto fijo* cuando $v_k = v_pi$.

  - De hecho, la convergencia de la secuencia de $v_k$ en $v_pi$ se da cuando $k --> infinity$.

  #framed[Como la política se evalúa en múltiples iteraciones, es más correcto denominar a este algoritmo #stress[EVALUACIÓN ITERATIVA DE LA POLÍTICA] (_iterative policy evaluation_).]

  Cada iteración en la evaluación de la política actualiza el valor de cada estado para producir una nueva función de valor aproximada $v_(k+1)$.

  #text(size: 15pt)[
    - Todas las actualizaciones en programación dinámica se denominan *_esperadas_* (_expected updates_) porque están basadas en la esperanza sobre todos los posibles siguientes estados (_vs._ en un posible estado aleatorio).
  ]

]

// *****************************************************************************

#let inpl = text[#emoji.chart.bar Evaluación síncrona _vs._ evaluación asíncrona]

#slide(title: [#inpl])[

  Computacionalmente, la implementación #stress[síncrona] de la evaluación iterativa de la política requiere de dos vectores:

  #cols[

    - Vector de #stress[valores originales] $v_k (s)$ :

    #v(.9cm)

    - Vector de #stress[valores actualizados] $v_(k+1) (s)$ :

  ][

    #table(
      columns: 4,
      inset: 12pt,
      align: horizon,
      [$v_k (s_0)$], [$v_k (s_1)$], [$dots$], [$v_k (s_n)$],
    )

    #table(
      columns: 4,
      inset: 12pt,
      align: horizon,
      [$v_(k+1) (s_0)$], [$v_(k+1) (s_1)$], [$dots$], [$v_(k+1) (s_n)$],
    )

  ]

  $dots$ ya que el cálculo de $v_k (s)$ requiere del valor de $v_(k+1) (s)$.

  No obstante, podemos simplificar el algoritmo y emplear *un único vector* donde los valores se sobreescriban.

  - Es lo que denominamos una versión _in-place_ o #stress[asíncrona] del algoritmo.

]

// *****************************************************************************

#let eval = text[#emoji.chart.bar Evaluación iterativa de la política]

#slide(title: [#eval])[

  #figure(image("images/iterative-policy-eval.png"))

]

// *****************************************************************************

#focus-slide("Ejemplo")

// *****************************************************************************

#let gridw = text[Ejemplo -- _Gridworld_ 3x3]

#slide(title: [#gridw])[

  #cols[

    #align(center)[
      #table(
        columns: 3,
        inset: 40pt,
        fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
        align: horizon,
        [$s_0$], [$s_1$], [$s_2$],
        [$s_3$], [$s_4$], [$s_5$],
        [$s_6$], [$s_7$], [$s_8$],
      )
    ]

  ][

    - Toda transición tiene recompensa = -1.

    - $s_0$ es el estado final a alcanzar.

    - Chocar contra una pared supone volver al mismo estado.

    - Asumimos $gamma = 1$, #h(0.1cm) $theta = 0.1$

    - Evaluación *síncrona*.

  ]

]


// *****************************************************************************

#slide(title: [#gridw])[

  #cols[

    #align(center)[
      #table(
        columns: 3,
        fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
        align: horizon,
        [$s_0$], [$s_1$\ #image("images/arrow.png", width: 50%)], [$s_2$\ #image("images/arrow.png", width: 50%)],
        [$s_3$\ #image("images/arrow.png", width: 50%)],
        [$s_4$\ #image(
            "images/arrow.png",
            width: 50%,
          )],
        [$s_5$\ #image("images/arrow.png", width: 50%)],

        [$s_6$\ #image("images/arrow.png", width: 50%)],
        [$s_7$\ #image(
            "images/arrow.png",
            width: 50%,
          )],
        [$s_8$\ #image("images/arrow.png", width: 50%)],
      )
    ]
  ][


    Evaluaremos una política $pi$ que asigna la *misma probabilidad* a todas las acciones:

    $ pi(a|s) = 0.25, forall a in cal(A)(s) $

    #figure(image("images/arrow.png"))

  ]

]


// *****************************************************************************

#slide(title: [#gridw])[

  #cols[

    #figure(image("images/Figure_0.png", width: 110%))

  ][


    Inicialmente:

    $ v^0_pi (s_i) = 0, #h(0.7cm) forall i in {0 dots 8} $


    Aplicaremos iterativamente la regla de actualización:

    #grayed[
      #set text(size: 18pt)
      $ V(s) <- sum_a pi(a|s) sum_(s',r) p(s',r|s,a) [r + gamma V(s')] $]

    hasta que: #h(1cm) $|v_(k+1) - v_k| < theta$ .

  ]


]

// *****************************************************************************

#slide(title: [#gridw])[

  #cols[

    Primera iteración: $v^1_pi (s_i)$

    #align(center)[#image("images/Figure_1.png", width: 110%)]

  ][

    #align(center)[
      $v^1_pi (s_1) &= 0.25 [-1 + gamma v^0_pi (s_8)] \
        &+ 0.25 [-1 + gamma v^0_pi (s_7)] \
        &+ 0.25 [-1 + gamma v^0_pi (s_6)] \
        &+ 0.25 [-1 + gamma v^0_pi (s_4)] = bold(-1)$

      #v(0.5cm)

      $v^1_pi (s_8) &= 0.25 [-1 + gamma v^0_pi (s_3)] \
        &+ 0.25 [-1 + gamma v^0_pi (s_1)] \
        &+ 0.25 [-1 + gamma v^0_pi (s_0)] \
        &+ 0.25 [-1 + gamma v^0_pi (s_0)] = bold(-1)$
    ]

  ]


]

// *****************************************************************************

#slide(title: [#gridw])[

  #cols[

    Segunda iteración: $v^2_pi (s_i)$


    #align(center)[#image("images/Figure_2.png", width: 110%)]

  ][

    #align(center)[
      #text(size: 16pt)[

        $v^2_pi (s_1) &= 0.25 [-1 + gamma underbrace(v^1_pi (s_0), #stress[0])] \
          &+ 0.25 [-1 + underbrace(v^1_pi (s_0), #stress[-1])] \
          &+ 0.25 [-1 + gamma v^1_pi (s_2)] \
          &+ 0.25 [-1 + gamma v^1_pi (s_4)] = bold(1.75)$

        #v(0.5cm)

        $v^2_pi (s_4) &= 0.25 [-1 + gamma underbrace(v^1_pi (s_0), #stress[-1])] \
          &+ 0.25 [-1 + gamma v^1_pi (s_3)] \
          &+ 0.25 [-1 + gamma v^1_pi (s_5)] \
          &+ 0.25 [-1 + gamma v^1_pi (s_7)] = bold(-2)$
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: [#gridw])[
  #cols[

    Tercera iteración: $v^3_pi (s_i)$

    #align(center)[#image("images/Figure_3.png", width: 110%)]

  ][

    #align(center)[_Continuamos iterando..._ #emoji.hourglass]

  ]

]


// *****************************************************************************

#slide(title: [#gridw])[
  #cols[

    Cuarta iteración: $v^4_pi (s_i)$

    #align(center)[#image("images/Figure_4.png", width: 110%)]

  ][

    #align(center)[_Continuamos iterando..._ #emoji.hourglass]

  ]

]

// *****************************************************************************

#slide(title: [#gridw])[
  #cols[

    Quinta iteración: $v^5_pi (s_i)$

    #align(center)[#image("images/Figure_5.png", width: 110%)]

  ][

    #align(center)[_Continuamos iterando..._ #emoji.hourglass]

  ]

]

// *****************************************************************************

#blank-slide[
  #align(center)[#image("images/later.jpg")]
]

// *****************************************************************************

#slide(title: [#gridw])[

  #cols[

    Última iteración: $v^78_pi (s_i)$

    #align(center)[#image("images/Figure_78.png", width: 110%)]

  ][

    #align(center)[
      *Convergencia* alcanzada:
      #grayed[$ v^78_pi #h(1cm) (Delta < theta) $]
    ]

  ]

]

// *****************************************************************************

#slide(title: [#gridw])[

  #cols(gutter: 1cm)[

    Última iteración: $v^78_pi (s_i)$

    #text(size: 15pt)[
      #align(center)[
        #table(
          columns: 3,
          fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
          align: horizon,
          [$v(s_0) = 0$],
          [$v(s_1) tilde.eq -14.9$\ #image(
              "images/arrow.png",
              width: 50%,
            )],
          [$v(s_2) tilde.eq -20.9$\ #image("images/arrow.png", width: 50%)],

          [$v(s_3) tilde.eq -14.9$ #image("images/arrow.png", width: 50%)],
          [$v(s_4) tilde.eq -20$\ #image(
              "images/arrow.png",
              width: 50%,
            )],
          [v($s_5) tilde.eq -23.2$\ #image("images/arrow.png",width:50%)],

          [$v(s_6) tilde.eq -21$\ #image("images/arrow.png", width: 50%)],
          [$v(s_7) tilde.eq -23.3$\ #image(
              "images/arrow.png",
              width: 50%,
            )],
          [$v(s_8) tilde.eq -25.1$\ #image("images/arrow.png", width: 50%)],
        )
      ]
    ]

  ][

    #align(center)[
      *Convergencia* alcanzada:
      #grayed[$ v^78_pi #h(1cm) (Delta < theta) $]
    ]

    Los valores obtenidos son una aproximación de los pasos necesarios para alcanzar $s_0$ desde cualquier estado _siguiendo una política aleatoria_.

  ]
]


// *****************************************************************************

#slide(title: [#gridw])[

  #framed[Si la actualización de valores empleada es #stress[síncrona], todos los valores tomados como referencia para obtener $v^(k+1)_pi (s_i)$ son $v^k_pi (s)$.]

  #framed[Por el contrario, la actualización #stress[asíncrona] permite que los valores actualizados se puedan utilizar tan pronto como son calculados.

    - Sólo se requiere un vector de valores.

    - La convergencia es más rápida.
  ]

  En el ejemplo anterior, se emplean *52* iteraciones para converger con el método #stress[asíncrono] _vs._ las *78* iteraciones empleando actualizaciones #stress[síncronas].

]

// *****************************************************************************

#focus-slide("Otro ejemplo...")

// *****************************************************************************

#slide(title: [#gridw limitado])[

  #cols[
    #align(center)[
      #table(
        columns: 3,
        fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
        align: horizon,
        [$s_0$], [$s_1$\ #image("images/arrow2.png", width: 50%)], [$s_2$\ #image("images/arrow2.png", width: 50%)],
        [$s_3$\ #image("images/arrow2.png", width: 50%)],
        [$s_4$\ #image(
            "images/arrow2.png",
            width: 50%,
          )],
        [$s_5$\ #image("images/arrow2.png", width: 50%)],

        [$s_6$\ #image("images/arrow2.png", width: 50%)],
        [$s_7$\ #image(
            "images/arrow2.png",
            width: 50%,
          )],
        [$s_8$\ #image("images/arrow2.png", width: 50%)],
      )
    ]

  ][

    Evaluemos ahora una política $pi'$ que *no permite ir hacia abajo*:

    $ pi'(#emoji.arrow.t.filled |s) = 0.33 $
    $ pi'(#emoji.arrow.l.filled |s) = 0.33 $
    $ pi'(#emoji.arrow.r.filled |s) = 0.33 $
    $ pi'(#emoji.arrow.b.filled |s) = 0 $

  ]

]


// *****************************************************************************

#slide(title: [#gridw limitado])[

  #cols[

    Convergencia: #h(0.1cm) $v^27_pi' (s_i)$

    #text(size: 15pt)[
      #align(center)[
        #table(
          columns: 3,
          fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
          align: horizon,
          [$v(s_0) = 0$],
          [$v(s_1) tilde.eq -5.5$\ #image(
              "images/arrow2.png",
              width: 50%,
            )],
          [$v(s_2) tilde.eq -8.2$\ #image("images/arrow2.png", width: 50%)],

          [$v(s_3) tilde.eq -5.2$ #image("images/arrow2.png", width: 50%)],
          [$v(s_4) tilde.eq -7.6$\ #image(
              "images/arrow2.png",
              width: 50%,
            )],
          [v($s_5) tilde.eq -9.3$\ #image("images/arrow2.png",width:50%)],

          [$v(s_6) tilde.eq -9.1$\ #image("images/arrow2.png", width: 50%)],
          [$v(s_7) tilde.eq -10.2$\ #image(
              "images/arrow2.png",
              width: 50%,
            )],
          [$v(s_8) tilde.eq -11.2$\ #image("images/arrow2.png", width: 50%)],
        )
      ]
    ]

  ][

    Se converge en un menor número de iteraciones (#stress[27] < 78).

    *¿Por qué?*

    #framed[
      - Se reducen las acciones que alejan al agente del estado final.

      - El número de acciones que influyen sobre el valor de los estados es menor.
    ]

  ]

]


// *****************************************************************************

#slide(title: [#gridw])[

  #cols[


    Convergencia: #h(0.1cm) $v^27_pi' (s_i)$

    #text(size: 15pt)[
      #align(center)[
        #table(
          columns: 3,
          fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
          align: horizon,
          [$v(s_0) = 0$],
          [$v(s_1) tilde.eq -5.5$\ #image(
              "images/arrow2.png",
              width: 50%,
            )],
          [$v(s_2) tilde.eq -8.2$\ #image("images/arrow2.png", width: 50%)],

          [$v(s_3) tilde.eq -5.2$ #image("images/arrow2.png", width: 50%)],
          [$v(s_4) tilde.eq -7.6$\ #image(
              "images/arrow2.png",
              width: 50%,
            )],
          [v($s_5) tilde.eq -9.3$\ #image("images/arrow2.png",width:50%)],

          [$v(s_6) tilde.eq -9.1$\ #image("images/arrow2.png", width: 50%)],
          [$v(s_7) tilde.eq -10.2$\ #image(
              "images/arrow2.png",
              width: 50%,
            )],
          [$v(s_8) tilde.eq -11.2$\ #image("images/arrow2.png", width: 50%)],
        )
      ]
    ]

  ][

    *¿Es mejor política que $pi$?* #emoji.arrow.r #stress[SÍ], ya que:

    #grayed[$ v_pi' (s) >= v_pi (s), #h(0.5cm) forall s in cal(S) $]

    El número de pasos necesarios para alcanzar $s_0$ siguiendo $pi'$ desde cualquier estado es menor o igual a los necesarios siguiendo $pi$.

    #text(size: 14pt)[
      - Hay menos acciones que, con cierta probabilidad, alejen al agente de $s_0$ provocándole ir hacia abajo.
    ]

  ]

]

// *****************************************************************************

#focus-slide(text-size: 40pt)[#emoji.chart.up Mejora de la política\ #text(size:21pt)[_Policy improvement_]]

// *****************************************************************************

#slide(title: [#impr])[

  #framed[*Objetivo*: #stress[mejorar una política $pi$ a partir de su funcion de valor $v_pi$]]

  - Problema de *control* $-->$ mejora de una política dada.

  - El objetivo perseguido calculando $v_pi$ para una política $pi$ es buscar cómo mejorarla.

  Podemos mejorar $pi$ #stress[actuando de forma voraz (_greedy_)] con respecto a los valores previamente calculados mediante evaluación iterativa de la política.

]

// *****************************************************************************

#slide(title: [#impr])[

  #let a = text(size: 16pt, fill: red)[Calculado mediante\ _policy evaluation_]
  #let b = text(size: 25pt, fill: red)[Política que maximiza $q_pi (s,a)$]

  La actualización de la política $pi -> pi'$ se hace de la siguiente forma:

  #grayed[

    $
      pi'(s) &= underbrace(op("argmax")_a q_pi (s,a), #b) \
      &= op("argmax")_a EE[R_(t+1) + gamma v_pi (S_(t+1)) | S_t = s, A_t = a] \
      &= op("argmax")_a sum_(s',r) p(s',r|s,a) [r + gamma underbrace(v_pi (s'), #a)] \
    $

  ]

]

// *****************************************************************************

#slide(title: [#impr])[

  #grayed[
    $ pi'(s) = op("argmax")_a sum_(s',r) p(s',r|s,a) [r + gamma v_pi (s')] $
  ]

  - $pi'$ es una nueva política que elige las acciones asociadas a mayores recompensas esperadas de acuerdo con $v_pi$.

  #framed[#emoji.books De acuerdo con el #stress[_teorema de mejora de la política_], _$pi'$ será siempre mejor o igual que $pi$_.]
]

// *****************************************************************************

#slide(title: [#impr])[

  Al proceso de obtención de una política mejorada a partir de una política anterior lo denominamos #stress[mejora de la política] (_policy improvement_).

  Si la política que tratamos de mejorar ya es óptima, entonces se cumplirá que:

  #grayed[
    #text(size: 25pt)[
      $ v_pi = v_pi' = v^* $
    ]
  ]

  #framed[Esto se cumple tanto para políticas *deterministas* como para *estocásticas*.]
]

// *****************************************************************************

#slide(title: "En resumen...")[

  1. Evaluamos la política actual $pi$, aproximando iterativamente su función de valor $v_pi$:
    #grayed[$ v_(k+1) (s) = sum_a pi(a|s) sum_(s',r) p(s',r|s,a) [r + gamma v_k (s')] $]

  2. Utilizamos $v_pi$ para obtener $pi'$, tal que:
    #grayed[$ pi' = op("argmax")_a sum_(s',r) p(s',r|s,a) [r + gamma v_pi (s')] $]

]

// *****************************************************************************

#slide(title: "En resumen...")[

  #cols[

    1. *_Policy evaluation_* ($pi$, $v^78_pi tilde.eq v_pi$)

      #text(size: 15pt)[
        #align(center)[
          #table(
            columns: 3,
            fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
            align: horizon,
            [$v(s_0) = 0$],
            [$v(s_1) tilde.eq -14.9$\ #image(
                "images/arrow.png",
                width: 50%,
              )],
            [$v(s_2) tilde.eq -20.9$\ #image("images/arrow.png", width: 50%)],

            [$v(s_3) tilde.eq -14.9$ #image("images/arrow.png", width: 50%)],
            [$v(s_4) tilde.eq -20$\ #image(
                "images/arrow.png",
                width: 50%,
              )],
            [v($s_5) tilde.eq -23.2$\ #image("images/arrow.png",width:50%)],

            [$v(s_6) tilde.eq -21$\ #image("images/arrow.png", width: 50%)],
            [$v(s_7) tilde.eq -23.3$\ #image(
                "images/arrow.png",
                width: 50%,
              )],
            [$v(s_8) tilde.eq -25.1$\ #image("images/arrow.png", width: 50%)],
          )
        ]
      ]

  ][

    2. *_Policy improvement_* ($pi -> pi'$)
      #text(size: 15pt)[
        #align(center)[
          #table(
            columns: 3,
            inset: (35pt, 35pt, 35pt),
            fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
            align: horizon,
            [$s_8$], [$s_7$ #emoji.arrow.l.filled], [$s_6$ #emoji.arrow.l.filled],
            [$s_5$ #emoji.arrow.t.filled],
            [$s_4$\ #emoji.arrow.l.filled #emoji.arrow.t.filled],
            [$s_3$ #emoji.arrow.l.filled],

            [$s_2$ #emoji.arrow.t.filled], [$s_1$ #emoji.arrow.t.filled], [$s_0$ #emoji.arrow.t.filled],
          )
        ]

        #text(size: 14pt)[_Hay varias políticas óptimas_]
      ]

  ]

]

// *****************************************************************************

#focus-slide(text-size: 40pt)[#emoji.arrows.cycle Iteración de la política\ #text(size:21pt)[_Policy iteration_]]

// *****************************************************************************

#let itp = text[#emoji.arrows.cycle Iteración de la política]

#slide(title: [#itp])[

  Hasta el momento, dada una política inicial $pi$, hemos obtenido su función de valor $v_pi$ y la hemos mejorado tal que:

  #let e = text(size: 20pt, fill: blue)[evaluación]
  #let i = text(size: 20pt, fill: red)[mejora]
  #let p = text(size: 27pt, fill: black)[\ *Iteración de la política*]

  #v(0.5cm)

  #grayed[
    #set text(size: 31pt)
    $underbrace(pi_0 underbrace(-->^E, #e) v_pi_0 underbrace(-->^I, #i) pi_1, #p)$
  ]


  #text(size: 19pt)[
    #framed[Denominamos #stress[iteración de la política] (_policy iteration_) a la aplicación de una #text(fill:blue)[evaluación iterativa de la política] seguida de una #text(fill:red)[mejora de la política].]
  ]
]

// *****************************************************************************

#slide(title: [#itp])[

  Si repetimos este proceso iterativamente, obtenemos una #stress[secuencia de políticas] que mejoran de forma monotónica:

  #v(.5cm)

  #grayed[
    $pi_0 -->^E v_pi_0 -->^I pi_1 -->^E v_pi_1 -->^I pi_2 --> dots -->^I pi^* -->^E v_(pi^*)$
  ]

  #align(center)[
    #framed[Finalmente se converge en la #stress[política óptima].]
  ]

]

// *****************************************************************************

#slide(title: [#itp])[
  #text(size: 33pt)[
    $ #emoji.arrows.cycle = (infinity times #emoji.chart.bar + #emoji.chart.up) times n_"iter" $
  ]
]

// *****************************************************************************

#slide(title: [#itp])[

  #cols[
    #align(center)[#image("images/iteration-loop.png", width: 52%)]
  ][
    #align(left)[#image("images/iteration-convergence.png", width: 100%)]
    $ pi, p, gamma --> "Policy evaluation" --> v_pi $
    $ pi, gamma --> "Policy improvement" --> pi^* $
  ]
]

// *****************************************************************************

#slide(title: [#itp])[

  #align(center)[#stress[_POLICY ITERATION_]]

  #cols[
    #text(size: 15pt)[
      #align(center)[
        *_POLICY EVALUATION_* ($pi_0 comma v^78_pi_1 tilde.eq v_pi_0$)
        #v(0.2cm)
        #table(
          columns: 3,
          fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
          align: horizon,
          [$v(s_0) = 0$],
          [$v(s_1) tilde.eq -14.9$\ #image(
              "images/arrow.png",
              width: 50%,
            )],
          [$v(s_2) tilde.eq -20.9$\ #image("images/arrow.png", width: 50%)],

          [$v(s_3) tilde.eq -14.9$ #image("images/arrow.png", width: 50%)],
          [$v(s_4) tilde.eq -20$\ #image(
              "images/arrow.png",
              width: 50%,
            )],
          [v($s_5) tilde.eq -23.2$\ #image("images/arrow.png",width:50%)],

          [$v(s_6) tilde.eq -21$\ #image("images/arrow.png", width: 50%)],
          [$v(s_7) tilde.eq -23.3$\ #image(
              "images/arrow.png",
              width: 50%,
            )],
          [$v(s_8) tilde.eq -25.1$\ #image("images/arrow.png", width: 50%)],
        )
      ]
    ]

  ][

    #align(center)[
      #text(size: 15pt)[
        *_POLICY IMPROVEMENT_* ($pi_1$)
      ]
      #table(
        columns: 3,
        inset: (30pt, 30pt, 30pt),
        fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
        align: horizon,
        [$s_8$], [$s_7$ #emoji.arrow.l.filled], [$s_6$ #emoji.arrow.l.filled],
        [$s_5$ #emoji.arrow.t.filled],
        [$s_4$ #emoji.arrow.l.filled #emoji.arrow.t.filled],
        [$s_3$ #emoji.arrow.l.filled],

        [$s_2$ #emoji.arrow.t.filled], [$s_1$ #emoji.arrow.t.filled], [$s_0$ #emoji.arrow.t.filled],
      )
    ]
  ]

]

// *****************************************************************************

#slide(title: [#itp])[

  #align(center)[#stress[_POLICY ITERATION_]]

  #cols[
    #text(size: 15pt)[
      #align(center)[
        *_POLICY EVALUATION_* ($pi_1 comma v^5_pi_1 tilde.eq v_pi_1$)
        #v(0.2cm)
        #table(
          columns: 3,
          fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
          align: horizon,
          [$v(s_0) = 0$],
          [$v(s_1) tilde.eq -1$\ #image(
              "images/arrow.png",
              width: 50%,
            )],
          [$v(s_2) tilde.eq -2$\ #image("images/arrow.png", width: 50%)],

          [$v(s_3) tilde.eq -1$ #image("images/arrow.png", width: 50%)],
          [$v(s_4) tilde.eq -2$\ #image(
              "images/arrow.png",
              width: 50%,
            )],
          [v($s_5) tilde.eq -3$\ #image("images/arrow.png",width:50%)],

          [$v(s_6) tilde.eq -2$\ #image("images/arrow.png", width: 50%)],
          [$v(s_7) tilde.eq -3$\ #image(
              "images/arrow.png",
              width: 50%,
            )],
          [$v(s_8) tilde.eq -4$\ #image("images/arrow.png", width: 50%)],
        )
      ]
    ]

  ][

    #align(center)[
      #text(size: 15pt)[
        *_POLICY IMPROVEMENT_* ($pi_2 tilde.eq pi^*$)
      ]
      #set text(size: 15pt)
      #table(
        columns: 3,
        inset: (30pt, 30pt, 30pt),
        fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) },
        align: horizon,
        [$s_8$], [$s_7$ #emoji.arrow.l.filled], [$s_6$ #emoji.arrow.l.filled],
        [$s_5$ #emoji.arrow.t.filled],
        [$s_4$ #emoji.arrow.l.filled #emoji.arrow.t.filled],
        [$s_3$ #emoji.arrow.l.filled #emoji.arrow.t.filled],

        [$s_2$ #emoji.arrow.t.filled],
        [$s_1$ #emoji.arrow.l.filled #emoji.arrow.t.filled],
        [$s_0$ #emoji.arrow.l.filled #emoji.arrow.t.filled],
      )

      #align(left)[
        #text(size: 15pt)[
          Son necesarias *2* iteraciones de la política para converger en $pi^*$.
          *Problemas más complejos requerirán un mayor número de iteraciones*.
        ]
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: [#itp])[
  #align(center)[
    #box(height: 500pt)[
      #image("images/policy-iteration.png", width: 80%)
    ]
  ]
]

// *****************************************************************************

#focus-slide("Hablando en Python...")

// *****************************************************************************

#slide(title: "Evaluación (síncrona) de la política")[
  #align(center)[
    #box(height: 500pt)[
      #text(size: 18pt)[
        ```python
        def sync_policy_eval(states, pi, theta):
          while (True):
              delta = 0
              states_old = copy.deepcopy(states)
              for state in states:
                  if not is_terminal(state):
                      v_old = state.value
                      v_new = 0
                      for action in pi[state]:
                          action_prob = pi[state][action]
                          if action_prob > 0:
                              next_state, reward = get_transition(
                                  state, action, states_old)
                              v_new += action_prob * \
                                  (reward + GAMMA * next_state.value)
                      state.value = v_new
                      delta = max(delta, abs(v_old - v_new))
              if (delta < theta):
                  break
        ```
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: "Evaluación (asíncrona) de la política")[
  #align(center)[
    #box(height: 500pt)[
      #text(size: 18pt)[
        ```python
        def async_policy_eval(states, pi, theta):
            while (True):
                delta = 0
                for state in states:
                    if not is_terminal(state):
                        v_old = state.value
                        v_new = 0
                        for action in pi[state]:
                            action_prob = pi[state][action]
                            if action_prob > 0:
                                next_state, reward = get_transition(
                                    state, action, states)
                                v_new += action_prob *
                                  (reward + GAMMA * next_state.value)
                        state.value = v_new
                        delta = max(delta, abs(v_old - v_new))
                if (delta < theta):
                    break
        ```
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: "Mejora de la política")[
  #align(center)[
    #box(height: 500pt)[
      #text(size: 15pt)[
        ```python
        def policy_improvement(states, pi):
          policy_stable = True
          for state in states:
              if not is_terminal(state):
                  old_actions = [action for action,
                                 prob in pi[state].items() if prob > 0]
                  action_values = {}
                  for action in pi[state]:
                      action_prob = pi[state][action]
                      if action_prob > 0:
                          next_state, reward = get_transition(
                              state, action, states)
                          action_values[action] = reward + GAMMA * next_state.value
                  best_actions = [action for action, value in action_values.items(
                  ) if value == max(action_values.values())]
                  for action in ACTIONS:
                      if action in best_actions:
                          pi[state][action] = 1 / len(best_actions)
                      else:
                          pi[state][action] = 0
                  if old_actions != best_actions:
                      policy_stable = False
          return policy_stable
        ```
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: "Iteración de la política")[
  #align(center)[
    #box(height: 500pt)[
      #text(size: 18pt)[
        ```python
        # states
        states = []
        for i in range(3):
            for j in range(3):
                states.append(State(i, j))

        # policy
        pi = {}
        for state in states:
            pi[state] = {}
            for action in ACTIONS:
                pi[state][action] = 1/len(ACTIONS)

        def policy_iteration(states, pi):
            policy_stable = False
            while not policy_stable:
                sync_policy_eval(states, pi)
                policy_stable = policy_improvement(states, pi)
        ```
      ]
    ]
  ]
]

// *****************************************************************************

#title-slide[Iteración de valor]

// *****************************************************************************

#slide(title: "Limitaciones de iteración de la política")[

  El algoritmo de #stress[iteración de la política] presenta un *problema*:

  #framed[*Cada iteración supone evaluar la política actual hasta alcanzar la convergencia*, siendo necesarias múltiples iteraciones.]

  #text(fill: red)[#emoji.warning *Dicha evaluación puede ser un proceso demasiado lento...*]

  #v(0.4cm)

  #text(size: 25pt)[
    $
      pi_0 -->^(bold(E) #h(0.1cm) #emoji.clock) v_pi_0 -->^I pi_1 -->^(bold(E) #h(0.1cm) #emoji.clock) v_pi_1 -->^I pi_2 --> dots
    $
  ]
]

// *****************************************************************************

#slide(title: "Limitaciones de iteración de la política")[

  La _evaluación iterativa de la política_ #stress[puede truncarse sin pérdida de información].

  #align(center)[#framed[#emoji.lightbulb No es necesario esperar a que los valores converjan.]]

  #grayed[
    $
      v_pi_1, v_pi_2, v_pi_3 dots, underbrace(colmath(v_pi_(k-2)) comma colmath(v_pi_(k-1))), v_pi_k = v_pi
    $
  ]

  Las funciones de valor aproximadas $colmath(v_pi_(k-2))$ y $colmath(v_pi_(k-1))$ pueden no haber convergido pero ser *estimaciones suficientes* para mejorar $pi$.

  - Es decir, $v_pi_(k-2)$, $v_pi_(k-1)$ y $v_pi_(k)$ #stress[pueden conducir a la misma política $pi'$].
]

// *****************************************************************************

#slide(title: "Limitaciones de iteración de la política")[

  En el ejemplo visto, la política obtenida mediante $pi = op("greedy")(V)$ *no varía* desde la iteración 4 hasta la 78. Es decir:

  #grayed[
    $ pi = op("greedy")(v^78_pi) = op("greedy")(v^4_pi) $
  ]

  Aunque las funciones de valor son diferentes, la política a la que conducen es la misma. Por tanto, #stress[no es necesario esperar a la convergencia de los valores para mejorar la política actual].

]

// *****************************************************************************

#slide(title: "Limitaciones de iteración de la política")[

  #align(center)[
    #cols[

      #text[$pi = op("greedy")(v^78_pi)$]
      #image("images/convergence-policy.png")

    ][

      #text[$pi = op("greedy")(v^4_pi)$]
      #image("images/non-convergence-policy.png")

    ]
  ]

]

// *****************************************************************************

#focus-slide(text-size: 40pt)[#emoji.arrow.l.hook Iteración de valor\ #text(size:21pt)[_Value iteration_]]


// *****************************************************************************

#let itv = text[#emoji.arrow.l.hook Iteración de valor]

#slide(title: [#itv])[

  La #stress[iteración de valor] (_value iteration_) es un caso extremo en el que #stress[solamente realizamos una iteración de _policy evaluation_], y seguidamente mejoramos nuestra política.

  - Es decir, el valor de cada estado se evalúa/actualiza una única vez.

  La iteración de valor equivale a convertir la *ecuación de optimalidad de Bellman* en una #stress[regla de actualización]:

  #grayed[$ v_(k+1) = max_a sum_(s',r) p(s',r|s,a)[r + gamma v_k (s')] $]

]

// *****************************************************************************

#slide(title: [#itv])[

  #grayed[$ v_(k+1) = max_a sum_(s',r) p(s',r|s,a)[r + gamma v_k (s')] $]

  #framed[
    - La *convergencia* está teóricamente garantizada.

    - En la práctica, el algoritmo de _value iteration_ converge cuando la diferencia etre $v_k$ y $v_(k+1)$ es lo suficientemente pequeña ($epsilon$).
  ]

]

// *****************************************************************************

#slide(title: [#itv])[

  Recordemos los diagramas correspondientes a las ecuaciones de optimalidad de Bellman...

  #figure(image("images/backup.png"))

]


// *****************************************************************************

#slide(title: [#itv])[

  #figure(image("images/value-iteration.png"))

]

// *****************************************************************************

#slide(title: [#itv])[
  #align(center)[
    #text(size: 40pt)[
      #emoji.arrow.l.hook $= (#emoji.chart.bar + #emoji.chart.up) times n_"iter"$
    ]
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #cols[

    Veamos cómo funciona #stress[_value iteration_] para el ejemplo visto.

    - En este caso consideramos $gamma = 0.9$
    #text(size:13pt)[_Aunque no tendrá efectos notables en la política final obtenida_].

  ][

    #align(center)[#image("images/vi-0.png")]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #box(height: 300pt)[
      #stress[Evaluación] de $pi_0$ #h(3cm) #stress[Mejora]: $pi_1 = op("greedy")(v^1_pi_0)$
      #image("images/vi-1.png")
    ]
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #box(height: 300pt)[
      #stress[Evaluación] de $pi_1$ #h(3cm) #stress[Mejora]: $pi_2 = op("greedy")(v^1_pi_1)$
      #image("images/vi-2.png")
    ]
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #box(height: 300pt)[
      #stress[Evaluación] de $pi_2$ #h(3cm) #stress[Mejora]: $pi_3 = op("greedy")(v^1_pi_2)$
      #image("images/vi-3.png")
    ]
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #box(height: 300pt)[
      #stress[Evaluación] de $pi_3$ #h(3cm) #stress[Mejora]: $pi_4 = op("greedy")(v^1_pi_3)$
      #image("images/vi-4.png")
    ]
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #box(height: 300pt)[
      #stress[Evaluación] de $pi_4$ #h(3cm) #stress[Mejora]: $pi_5 = op("greedy")(v^1_pi_4) = pi_4$ \ #h(4.8cm) #text(fill:green)[*CONVERGENCIA*] #emoji.checkmark.box
      #v(-.5cm)
      #image("images/vi-5.png")
    ]
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #cols[

    #emoji.checkmark.box En 5 _iteraciones de valor_ hemos obtenido la *política óptima*.

    - Son más iteraciones totales que en el caso de _policy iteration_ (5 > 2), pero son mucho más cortas.

    - La elección de un método u otro dependerá del problema, aunque #stress[generalmente _value iteration_ es más rápido].

  ][

    #align(center)[#image("images/vi-5.png")]

  ]
]

// *****************************************************************************

#focus-slide[¿Qué método elegir?]

// *****************************************************************************

#slide(title: "Comparativa")[

  #align(center)[

    #table(
      columns: 2,
      inset: 18pt,
      fill: (x, y) => if x == 0 and y == 0 { green.lighten(80%) } else if x == 1 and y == 0 { blue.lighten(85%) },
      table.header(
        [*Iteración de la política*],
        [*Iteración de valor*],
      ),

      [Parte de una política aleatoria], [Parte de una función de valor aleatoria],
      [Algoritmo más complejo. Implica:\ (1) evaluación hasta convergencia\ (2) mejora de la política\ en varias iteraciones],
      [Algoritmo más simple:\ un sólo paso incluye\ evaluación y mejora],

      [Requiere pocas iteraciones\ para converger],
      [Requiere más iteraciones\ para converger, aunque\ generalmente es más rápido],
    )
  ]

]

// *****************************************************************************

#focus-slide[Programación dinámica asíncrona]


// *****************************************************************************

#slide(title: "Programación dinámica asíncrona")[

  #set text(size: 18pt)

  #cols[

    Los algoritmos estudiados pueden converger en una política óptima *sin necesidad de actualizar todos los estados en cada iteración*.

    - Esto puede ser útil para reducir el coste computacional por iteración en entornos con un gran número de estados.

    - La #stress[programación dinámica asíncrona] supone actualizar valores de forma irregular.

    - La aplicación de métodos asíncronos dependerá de la naturaleza del problema abordado.

  ][

    #v(1cm)

    #align(center)[
      #table(
        columns: 3,
        inset: 40pt,
        fill: (x, y) => if x == 0 and y == 0 { green.lighten(70%) } else if x > 0 and y > 0 { red.lighten(80%) } else {
          blue.lighten(70%)
        },
        align: horizon,
        [$s_0$], [$s_1$], [$s_2$],
        [$s_3$], [$s_4$], [$s_5$],
        [$s_6$], [$s_7$], [$s_8$],
      )
    ]
  ]

]

// *****************************************************************************

#slide(title: "Programación dinámica asíncrona")[


  #framed(title: "Ejemplos de aplicación")[

    - Alternancia en la actualización de estados en posiciones pares/impares.

    - Actualizar más frecuentemente los estados cercanos a estados finales.

    - Actualizar con menor frecuencia aquellos estados con más transiciones posibles (mayor coste computacional).

    - _Etc_.
  ]
]

// *****************************************************************************

#title-slide[Iteración de la política generalizada]

// *****************************************************************************

#slide(title: "Iteración de la política generalizada")[

  Hemos visto que la *#itp* consiste en la alternancia entre:

  - *#eval*: hacer consistente la función de valor con la política actual.

  - *#impr*: construir una política _greedy_ con respecto a la función de valor actual.

  $ pi_0 -->^E v_pi_0 -->^I pi_1 -->^E v_pi_1 -->^I pi_2 --> dots -->^I pi^* -->^E v_(pi^*) $

  $ pi_0 -->^E q_pi_0 -->^I pi_1 -->^E q_pi_1 -->^I pi_2 --> dots -->^I pi^* -->^E q_(pi^*) $

]

// *****************************************************************************

#slide(title: "Iteración de la política generalizada")[

  Podemos generalizar el proceso de evaluación + mejora empleando el término #stress[iteración de la política generalizada] (_generalized policy iteration_, o *GPI*).

  #text(size: 40pt)[
    $ pi arrows.lr v $
  ]

  #v(.4cm)
  #framed(title: "Iteración de la política generalizada")[
    Conjunto de algoritmos basados en la alternancia entre _policy evaluation_ y _policy improvement_ para obtener una política óptima.
  ]

  - Independientemente de la granularidad y detalles de implementación.

]

// *****************************************************************************

#slide(title: "Iteración de la política generalizada")[

  - *#itv* sólo utiliza una iteración de _policy evaluation_ entre cada _policy improvement_:
    #h(1cm) #emoji.arrow.l.hook $= (#emoji.chart.bar + #emoji.chart.up) times n_"iter"$

  - *#itp* utiliza los valores de convergencia de _policy evaluation_ antes de cada _policy improvement_:
    #h(1cm) $#emoji.arrows.cycle = (infinity times #emoji.chart.bar + #emoji.chart.up) times n_"iter"$

  - *Cualquier método intermedio entre iteración de valor e iteración de la política* utiliza un número arbitrario $K$ de evaluaciones antes de cada mejora de la política: $ #emoji.quest = (K times #emoji.chart.bar + #emoji.chart.up) times n_"iter" $

  - También tenemos que considerar los *métodos asíncronos* que siguen una actualización de valores irregular.

]

// *****************************************************************************

#slide(title: "Iteración de la política generalizada")[

  #box(height: 360pt, inset: 20pt, outset: 10pt, radius: 10pt, stroke: red)[

    #text(fill: red, size: 22pt)[*¡ TODOS ESTÁN DENTRO DE GPI !*]
    #v(0.5cm)

    #text(size: 17pt)[
      - *#itv* sólo utiliza una iteración de _policy evaluation_ entre cada _policy improvement_:
        #h(1cm) #emoji.arrow.l.hook $= (#emoji.chart.bar + #emoji.chart.up) times n_"iter"$

      - *#itp* utiliza los valores de convergencia de _policy evaluation_ antes de cada _policy improvement_:
        #h(1cm) $#emoji.arrows.cycle = (infinity times #emoji.chart.bar + #emoji.chart.up) times n_"iter"$

      - *Cualquier método intermedio entre iteración de valor e iteración de la política* utiliza un número arbitrario $K$ de evaluaciones antes de cada mejora de la política: $ #emoji.quest = (K times #emoji.chart.bar + #emoji.chart.up) times n_"iter" $

      - También tenemos que considerar los *métodos asíncronos* que siguen una actualización de valores irregular.
    ]
  ]
]


// *****************************************************************************

#slide(title: "Iteración de la política generalizada")[


  De hecho, #stress[la mayoría de métodos de RL se definen en el marco de GPI]:

  #framed[
    #set text(size: 18pt)
    1. Política y función de valor identificadas.

    2. La política se mejora a partir de la función de valor.

    3. La función de valor se actualiza empleando la política.

    4. La función de valor se estabiliza cuando es consistente con la política actual.

    5. La política se estabiliza cuando es _greedy_ con respecto a la función de valor actual.
  ]

  Se trata de un proceso donde política y función de valor cooperan y compiten al mismo tiempo hasta obtener $pi^*$ y $v_(pi^*)$
]

// *****************************************************************************

#title-slide("Eficiencia en programación dinámica")

// *****************************************************************************

#slide(title: "Eficiencia de la programación dinámica")[

  Los algoritmos de programación dinámica son métodos bastante *eficientes* para resolver MDPs en comparación con otras alternativas.

  #emoji.clock El tiempo de ejecución es #stress[polinomial con respecto al número de estados y acciones] (en el peor de los casos).

  #framed[
    - Mejor que otras alternativas, como *algoritmos de búsqueda* en el espacio de políticas.
    - La *programación lineal* es otra alternativa que en la mayoría de situaciones _NO_ supera a la programación dinámica.
  ]

  #text(
    fill: red,
  )[No obstante, los algoritmos de programación dinámica *no son prácticos en problemas con espacios de estados/acciones muy grandes*.]

]

// *****************************************************************************

#slide(title: "Eficiencia de la programación dinámica")[

  Sobre qué algoritmo de DP elegir, no hay un consenso en el uso de *#itp* o *#itv*. Dependerá del coste computacional de las evaluaciones.

  - En problemas con grandes espacios de estados, los *métodos asíncronos* son una buena alternativa.

  También existen *alternativas* basadas en GPI que limitan la computación y memoria:

  #framed[
    - _¿Para qué actualizar estados por los que no se va a pasar nunca?_
    - Es lo que denominamos #stress[actualizaciones selectivas] (_selective updates_).
  ]
]

// *****************************************************************************

#slide(title: "Eficiencia de la programación dinámica")[

  En general, la principal limitación de la programación dinámica es que se ve considerablemente afectada por la #stress[dimensionalidad del problema] (_the curse of dimensionality_).

  - El tamaño del espacio de estados crece exponencialmente a medida que aumenta el número de características relevantes en el problema abordado.
]

// *****************************************************************************

#title-slide("Trabajo propuesto")

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  #box(height: 500pt)[
    #text(size: 18pt)[

      - Analizar los #stress[algoritmos] vistos:
        - #link("https://github.com/manjavacas/rl-temario/tree/main/ejemplos/policy_iteration")
        - Prueba a implementarlos y comprobar su convergencia en un entorno de *Gymnasium*.
        - Compara los *tiempos de ejecución*, variando el número de *estados* y *acciones*.
      - Profundizar sobre el concepto *"_curse of dimensionality_"* y conocer su impacto en RL.

      #text(size: 24pt)[*Bibliografía y recursos*]

      #text(size: 18pt)[
        - *Capítulo 4* de Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction.
        - #link("https://cs.stanford.edu/people/karpathy/reinforcejs/gridworld_dp.html")
        - #link("https://www.youtube.com/watch?v=Nd1-UUMVfz4&t=2148s")
        - #link("https://www.youtube.com/watch?v=l87rgLg90HI")
        - #link("https://www.youtube.com/watch?v=sJIFUTITfBc")
        - #link("https://www.youtube.com/watch?v=_j6pvGEchWU")
      ]
    ]
  ]
]


// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Programación dinámica",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)
