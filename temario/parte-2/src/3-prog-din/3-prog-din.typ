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

#title-slide("Trabajo propuesto")

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  - ...
  - ...

  #text(size: 24pt)[*Bibliografía y vídeos*]

]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Programación dinámica",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)
