#import "@preview/typslides:1.2.4": *

#show: typslides.with(
  ratio: "16-9",
  theme: "yelly",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)

#let colmath(x, color: red) = text(fill: color)[$#x$]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Aproximación de políticas",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents(title: "Contenidos")

// *****************************************************************************

#title-slide("Políticas parametrizadas")

// *****************************************************************************

#slide(title: [Recapitulando...])[

  En el tema anterior vimos cómo aproximar funciones de valor para, posteriormente, obtener una política óptima.

  El proceso seguido era el siguiente:

  1. A partir de la interacción con el entorno, ajustábamos un *modelo* (ej. lineal, red neuronal...) para aproximar la #stress[función de valor], ya sea $hat(v)(s, bold(w)) tilde.eq v(s)$ o $hat(q)(s,a, bold(w)) tilde.eq q(s,a)$.
    - Empleábamos el *descenso del gradiente* para minimizar el error en las predicciones.
    - Asegurábamos la exploración mediante $epsilon$-_greedy_.

  2. Una vez ajustado nuestro modelo, lo empleábamos para elegir aquellas acciones que maximizasen el retorno esperado.

]

// *****************************************************************************

#slide[

  #grayed[
    #emoji.lightbulb _Do not solve a more general problem as an intermediate step._
    #align(right)[$tilde$ Vladimir Vapnik]
  ]

]

// *****************************************************************************

#slide(title: [Políticas parametrizadas])[

  Estamos aprendiendo una función de valor parametrizada para posteriormente derivar la política óptima...

  #align(center)[
    #framed[#emoji.lightbulb ¿Por qué no emplear directamente una #stress[política parametrizada]?]
  ]

  - Vamos a estudiar *algoritmos basados en una política parametrizada*, que seleccionan acciones sin consultar la función de valor.

  - La función de valor puede seguir siendo utilizada, pero no se requiere para seleccionar acciones.

]

// *****************************************************************************

#slide(title: [Políticas parametrizadas])[

  Representamos el vector de parámetros de la política como $bold(theta) in RR^d'$.

  De esta forma, definimos una política parametrizada de la siguiente forma:

  #grayed[
    $ pi(a | s, bold(theta)) = Pr{A_t = a | S_t = s, bold(theta)_t = bold(theta)} $
  ]

  #set text(size: 17pt)
  - Si el método empleado usa además una función de valor aproximada, entonces volveremos a contar con el vector de pesos $bold(w) in RR^d$ y $hat(v)(s, bold(w))$.

]

// *****************************************************************************

#slide(title: [Gradiente de la política])[

  Ajustaremos $bold(theta)$ basándonos en el *gradiente* de una medida escalar $J(bold(theta))$ que representa el rendimiento.

  - Como estos métodos buscan MAXIMIZAR el rendimiento, las actualizaciones se basan en el *gradiente ascendente* de $J$:

  #grayed[$bold(theta)_(t+1) = bold(theta)_t + alpha hat(gradient J(bold(theta)_t))$]

  #text(
    size: 19pt,
  )[donde $hat(gradient J(bold(theta)_t)) in RR^d'$ es una estimación estocástica cuya expectación aproxima el gradiente de $J(bold(theta)_t)$.]

  #framed[Todos los métodos que siguen este esquema se denominan #stress[_policy gradient_] (métodos basados en el *gradiente de la política*).]
]


// *****************************************************************************

#slide(title: [Métodos actor-crítico])[

  También veremos métodos que aproximan la *política* y la *función de valor* al mismo tiempo.

  Estos se denominan #stress[actor-crítico] (_actor-critic_), donde:

  - El *actor* es la política aprendida.

  - El *crítico* es la función de valor aproximada (normalmente, estado-valor).
]

// *****************************************************************************

#title-slide("Aproximación de políticas")

// *****************************************************************************

// *****************************************************************************

#slide(title: [Aproximación de políticas])[

  ...

]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Aproximación de políticas",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)
