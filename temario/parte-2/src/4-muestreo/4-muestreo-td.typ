#import "@preview/typslides:1.2.5": *

#show: typslides.with(
  ratio: "16-9",
  theme: "greeny",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)

#let colmath(x, color: red) = text(fill: color)[$#x$]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: [Métodos basados en muestreo: _TD-learning_],
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents(title: "Contenidos")

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

  #grayed[$ V(S_t) <- V(S_t) + alpha [colmath(G_t) - V(S_t)] $]

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

  Es decir, el #text(fill:orange)[retorno esperado, $G_t$,] es igual a la suma de la #text(fill:blue)[recompensa inmediata, $R_(t+1)$,] y el #text(fill:red)[retorno descontado futuro, $gamma G_(t+1)$].

  Por definición, este es igual a #text(fill:olive)[la función de valor descontada del siguiente estado, $gamma v_pi (S_(t+1))$].

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


// *****************************************************************************

#slide(title: [#td])[

  #grayed[ $ V (S_t) <- V (S_t) + alpha [R_(t+1) + gamma V (S_(t+1)) - V (S_t)] $ ]

  #v(.5cm)

  El _TD-error_ mide la diferencia entre dos predicciones: la actual y la recién obtenida. \
  #h(2cm) #emoji.arrow.r Es decir, mide la #stress[diferencia temporal], o _temporal difference_.

  #v(.5cm)

  #framed(title: "¿Cómo afecta el valor de $alpha$ a la convergencia de TD?")[
    Si $alpha$ es más pequeño, TD converge más despacio, pero disminuye el error.
  ]

]

// *****************************************************************************

#slide(title: [#td])[

  #framed[
    Decimos que TD está basado en #stress[_bootstrapping_] porque las actualizaciones de la función de valor estimada $V(S_t)$ se basan en otro valor estimado $V(S_(t+1))$.
  ]

  _... y no valores reales como $G_t$._

  - Se dice que el _TD-target_ es, por tanto, #stress[una estimación sesgada] de la función de valor real $v_pi$.

  Una ventaja frente a MC es que *la varianza es mucho menor*, ya que el _TD-target_ solamente depende de una acción/transición/recompensa, por lo que no se acumula tanta aleatoriedad.

  #text(fill: olive)[#emoji.lightning En la práctica, esto se traduce en un aprendizaje más rápido.]

]

// *****************************************************************************

#slide(title: [#td])[

  #framed[
    _Scalable model-free learning_

    _Prediction learning_

    _It is the unsupervised supervised learning_

    _Temporal difference is a method for learning to predict_

    _Learning a guess from a guess_

    _TD-error emulates dopamine in mammals_
  ]

  #align(right)[$tilde$ _Richard Sutton_]

]



// *****************************************************************************

#slide(title: [#td])[

  #framed(
    title: [#emoji.books Morales, M. (2020). _Grokking deep reinforcement learning_. Manning Publications.],
  )[_TD methods estimate $v_pi (s)$ using an estimate of $v_pi (s)$. It *bootstraps* and makes a guess from a guess; it uses an *estimated return* instead of the actual return. More concretely, it uses $R_(t+1) + gamma V_t (S_(t+1))$ to calculate and estimate $V_(t+1) (S_t)$._

    #v(0.2cm)

    _Because it also uses *one step of the actual return* $R_(t+1)$, things work out fine. That reward signal $R_(t+1)$ progressivaley "*injects reality*" into the estimates_.

  ]
]


// *****************************************************************************

#let tde = text[#emoji.clock.timer TD]
#let mce = text[#emoji.calendar MC]
#let dpe = text[#emoji.playback.shuffle DP]

#focus-slide[#tde\ #mce\ #dpe]


// *****************************************************************************

#slide(title: [#td _vs_. MC])[

  Una posible interpretación...
  #framed[#emoji.clock.timer #h(0.3cm) *TD* es similar a corregir tu comportamiento tan pronto como puedas. No esperas a observar las repercusiones finales de tus acciones, sino que te basas en el _feedback_ inmediato + tus expectativas futuras.]
  #framed[#emoji.calendar #h(0.3cm) *MC* equivale a realizar una acción y esperar a observar sus resultados a largo plazo para ver si fue buena o mala. En función de esto, modificas tu comportamiento.]

]

// *****************************************************************************


#slide(title: [#td _vs_. MC y DP])[

  #framed(
    title: text(
      size: 19pt,
    )[#emoji.books Sutton, R. S., & Barto, A. G. (2018). _Reinforcement learning: An introduction_. MIT press.],
  )[

    _If one had to identify one idea as central and novel to reinforcement learning, it would undoubtedly be *temporal-difference (TD) learning*._

    #v(0.2cm)

    _TD learning is a *combination* of *Monte Carlo* ideas and *dynamic programming* (DP) ideas. Like Monte Carlo methods, TD methods can learn directly from raw *experience without a model* of the environment’s dynamics. Like DP, TD methods update estimates based in part on other learned *estimates*, without waiting for a final outcome (they *bootstrap*)_.

  ]

]


// *****************************************************************************

#slide(title: [#td _vs_. MC y DP])[

  #tde combina:

  - El #stress[muestreo] de #mce.

  - El #stress[_bootstrapping_] de #dpe.

  #align(center)[#image("images/mc_td_dp.png")]

]


// *****************************************************************************

#slide(title: [_Sample updates_ vs. _Expected updates_])[


  #text(size: 25pt)[
    #align(center)[#framed[#text(fill:olive)[_Sample updates_] _vs._ #text(fill:blue)[_Expected updates_]]]
  ]
  #v(1cm)
  #columns(2)[

    #stress[_Sample updates_] (#mce, #tde): se basan en *un único estado sucesor* aleatorio (o par acción-estado).
    #v(0.5cm)

    #stress[_Expected updates_] (#dpe): se basan en una *distribución completa de todos los posibles estados sucesores* (o pares acción-estado).

    #colbreak()
    #align(center)[#image("images/updates-diag.png")]
  ]

]

// *****************************************************************************

#slide(title: [_Sample updates_])[


  #align(center)[#framed[*#mce* y *#tde* actualizan valores a partir de muestras aleatorias (actualizaciones muestreadas o #stress[_sample updates_]).]]

  #columns(2)[
    #v(.1cm)
    Cada actualización supone:

    1. _Mirar hacia delante_ #emoji.arrow.r hacia un posible estado sucesor aleatorio (o par acción-estado).

    2. Usar el _valor del sucesor y la recompensa obtenida_ para calcular un valor estimado.

    3. _Actualizar_ el valor estimado original.

    #colbreak()

    #align(center)[#image("images/td.png", width: 25%)]
    #text(size: 15pt)[#align(center)[Diagrama _backup_ de TD(0)]]
  ]

]


// *****************************************************************************

#slide(title: [_TD error vs. MC error_])[

  El #stress[error en TD] mide la diferencia entre el valor estimado de $S_t$ y la estimación actualizada $R_(t+1) + gamma V(S_(t+1))$.

  #grayed[$ delta_t = R_(t+1) + gamma V(S_(t+1)) - V(S_t) $]

  El #stress[error en MC] equivale a la suma de errores TD consecutivos (#text(fill:blue)[MC error = $sum$ TD errors]). Esto es:

  #grayed[$ G_t - V(S_t) = sum_(k=t)^(T-1) gamma^(k-t) delta_k $]

]


// *****************************************************************************

#slide(title: [_TD error vs. MC error_])[

  #set text(size: 20pt)
  #box(height: 500pt)[
    El #stress[error en TD] ($delta$) mide la diferencia entre el valor estimado de $S_t$ y la estimación actualizada $R_(t+1) + gamma V(S_(t+1))$.

    #grayed[$delta_t = underbrace(R_(t+1) + gamma V(S_(t+1)), "Nuevo valor estimado") - underbrace(V(S_t), #[Estimación\ actual])$]

    - El _TD-error_ es proporcional a los cambios a lo largo del tiempo del valor estimado.

    El #stress[MC error] es equivalente a la suma de _TD-errors_ consecutivos:

    #grayed[$G_t - V(S_t) = sum_(k=t)^(T-1) gamma^(k-t) delta_k$]
  ]

]


// *****************************************************************************

#slide(title: "En resumen...")[

  #set text(size: 19pt)
  #box(height: 400pt)[
    #columns(2)[

      #align(center)[#framed[Ventajas de #tde _vs._ #dpe]]

      - Al basarse en la *experiencia*, no necesitamos un modelo del entorno.

        - Recompensas para cada par acción-estado
        - Probabilidades de transición
        - Etc.

      - Permite abordar *problemas con grandes espacios de estados/acciones* de forma más eficiente.

      #colbreak()

      #align(center)[#framed[Ventajas de #tde _vs._ #mce]]

      - Permite abordar problemas con *episodios largos* de forma más eficiente.
      - Alternativa a MC en *problemas continuados*.
      - TD aprende transición-a-transición, por lo que no depende de acciones tomadas en el futuro.
        - MC requiere esperar al final del episodio.
        - TD *sólo necesita el siguiente _timestep_*.

    ]
  ]
]


// *****************************************************************************

#title-slide([_n-step_ TD])

// *****************************************************************************

#slide(title: [_n-step_ TD])[

  Hemos visto la actualización de valores en TD(0) solamente considera el estado *inmediatamente posterior* (#stress[_1-step TD_]).

  #grayed[ $ G_(t:t+1) = R_(t+1) + gamma V_(t) (S_(t+1)) $ ]


  Pero TD permite tantas estimaciones hacia delante como queramos #emoji.arrow.r #h(0.4cm) #stress[_TD(n)_].

  Por ejemplo, el _target_ de _TD(1)_ sería:

  #grayed[ $ G_(t:t+2) = R_(t+1) + gamma R_(t+2) + gamma^2 V_(t+1) (S_(t+2)) $ ]

]


// *****************************************************************************

#slide(title: [_n-step_ TD])[

  En general:

  #grayed[ $ G_(t:t+n) = R_(t+1) + gamma R_(t+2) + ... + gamma^(n-1) R_(t+n) + gamma^n V_(t+n-1) (S_(t+n)) $ ]


  Lo que resulta en la siguiente actualización de los _state-values_:

  #grayed[ $ V_(t+n)(S_t) = V_(t+n-1) (S_t) + alpha[G_(t:t+n) - V_(t+n-1) (S_t)], #h(1cm) 0=<t<T $ ]

  Es lo que denominamos #stress[_n-step_ TD].

]


// *****************************************************************************

#slide(title: [_n-step_ TD])[
  #align(center)[
    #box(height: 450pt)[
      El caso extremo es #stress[Monte Carlo]:
      #image("images/td-mc.png", width: 50%)
    ]
  ]
]


// *****************************************************************************

#slide(title: [_n-step_ TD])[
  #align(center)[
    #box(height: 400pt)[
      #image("images/n-step-td.png")
    ]
  ]
]


// *****************************************************************************

#focus-slide("Garantías de TD")

// *****************************************************************************

#slide(title: "Garantías de TD")[

  #box(height: 400pt)[
    #framed[_¿Pero TD es un método sólido/robusto? ¿Podemos garantizar la *convergencia* en $v_pi$, $q_pi$?_]


    #emoji.checkmark.box #text(fill:olive)[*¡SÍ!*] Para cualquier política $pi$, está demostrado que TD converge en la función de valor real $v_pi$, $q_pi$.

    #framed[_Si MC y TD convergen asintóticamente en los valores correctos... ¿Qué método lo hace más *rápido*? ¿Cuál hace un uso más *eficiente* de los datos?_]

    #emoji.arrow.r Si bien no existe una demostración formal concreta, empíricamente se observa que, en problemas estocásticos, *#tde tiende a converger más rápido que un #mce con $alpha$ constante*.
  ]
]


// *****************************************************************************

#title-slide("SARSA")

// *****************************************************************************

#slide(title: [Control TD])[

  #cols[
    Una vez vista la aplicación de TD en #stress[predicción], pasamos a abordar el problema de #stress[control].

    De nuevo, seguiremos el patrón de *GPI* (evaluación + mejora), pero empleando TD en la evaluación/predicción.

    - También volvemos a encontrarnos con el dilema *exploración--explotación*, que abordaremos desde dos aproximaciones: métodos #stress[_on-policy_] y #stress[_off-policy_], como en MC.
  ][
    #align(center)[#image("images/sarsa-gpi.png")]
  ]

]

// *****************************************************************************

#slide(title: [SARSA: control TD _on-policy_])[

  #framed[Buscamos aprender la #stress[función acción-valor] $q_pi (s,a)$ y obtener así la *política óptima*.]

  Podemos hacerlo de forma similar al caso de $v_pi$...

  - Antes considerábamos transiciones de *estado* a *estado* y aprendíamos el valor de los estados.

  - Ahora, consideramos transiciones $(s,a)$ a $(s,a)$ y aprendemos los valores de los pares *acción--estado*.

  #align(center)[#image("images/sarsa.png", width: 102%)]

]

// *****************************************************************************

#slide(title: [SARSA: control TD _on-policy_])[

  La #stress[regla de actualización] de los _action values_ es la siguiente:

  #grayed[$ Q(S_t, A_t) <- Q(S_t, A_t) + alpha[R_(t+1) + gamma Q(S_(t+1), A_(t+1)) - Q(S_t, A_t)] $]

  - Esta regla se aplica en cada transición desde estados $S_t$ no terminales.

  - Si $S_(t+1)$ es terminal, $Q(S_(t+1), A_(t+1)) = 0$, o lo que es lo mismo:

  #grayed[$ Q(S_t, A_t) <- Q(S_t, A_t) + alpha[R_(t+1) - Q(S_t, A_t)] $]

  - La convergencia de $Q$ en $q_pi$ empleando TD(0) está demostrada.

]


// *****************************************************************************

#slide(title: [SARSA: control TD _on-policy_])[

  #let sarsa = $<S_t, A_t, R_(t+1), S_(t+1), A_(t+1)>$
  #let sar = text(fill: olive, size: 40pt)[\ S A R S A]

  #grayed[$ Q(S_t, A_t) <- Q(S_t, A_t) + alpha[R_(t+1) + gamma Q(S_(t+1), A_(t+1)) - Q(S_t, A_t)] $]

  #v(.4cm)
  #align(center)[
    Esta regla de actualización emplea todos los elementos de la quíntupla

    $ underbrace(#sarsa, bold(#sar)) $
  ]

]

// *****************************************************************************

#slide(title: [SARSA: control TD _on-policy_])[

  #cols[

    Es relativamente sencillo diseñar un algoritmo de #stress[control _on-policy_] basado en el método de predicción de SARSA:

    1. Como en cualquier método _on-policy_, estimamos continuamente $q_pi$, siendo $pi$ nuestra política de comportamiento.

    2. Al mismo tiempo, $pi$ se actualiza de forma *_greedy_* con respecto al $q_pi$ estimado.

    Se emplea una política #stress[$epsilon$-_greedy_] o, en general $epsilon$-_soft_.
  ][
    #text(size: 15pt)[#align(center)[Diagrama _backup_ de SARSA]]
    #align(center)[#image("images/sarsa-back.png", width: 30%)]
  ]

]

// *****************************************************************************

#slide(title: [SARSA: control TD _on-policy_])[
  #align(center)[
    #image("images/sarsa-algo.png")
  ]
]


// *****************************************************************************

#slide(title: [SARSA: control TD _on-policy_])[

  #framed[
    SARSA es un método basado en experiencia/muestreo (_sample-based_) que resuelve la #stress[ecuación de Bellman] para _action-values_ $q(s,a)$.
  ]

  - Al ser *_on-policy_*, cuenta con una única política (la de comportamiento).

  - SARSA *aprende rápido* durante cada episodio. En caso de que la política actual no esté dando buenos resultados, se actualiza rápidamente sin esperar al final del episodio.

]

// *****************************************************************************

#slide(title: [Diagramas _backup_])[
  #align(center)[#image("images/sarsa-backup.png")]
]

// *****************************************************************************

#title-slide([_Q-learning_])

// *****************************************************************************

#slide(title: [_Q-learning_: control TD _off-policy_])[

  #framed[Uno de los mayores hitos en el campo del aprendizaje por refuerzo fue el desarrollo de un algoritmo de #stress[control _off-policy_ basado en TD], conocido como #stress[_Q-learning_] (Watkins, 1989).]

  La regla de actualización en la que se basa es la siguiente:

  #grayed[$
      Q(S_t, A_t) <- Q(S_t, A_t) + alpha[R_(t+1) + gamma #h(0.1cm) bold("max"_a) Q(S_(t+1), a) - Q(S_t, A_t)]
    $]

  En este caso, la función acción-valor $Q$ se aproxima directamente a $q_*$ (la función acción-valor óptima).

]

// *****************************************************************************

#slide(title: [_Q-learning_ _vs._ SARSA])[

  #framed[_Q-learning_ no itera entre _policy evaluatoin_ y _policy improvement_.\ *Aprende los valores óptimos directamente.*]

  #framed[Tiene un #stress[_TD-target_] *más estable* que SARSA, porque sólo cambia si cambia el valor máximo de $Q(S_(t+1), A_(t+1))$.]

  #v(.4cm)

  - *SARSA*: #h(3.95cm) #text(fill:olive)[$R_(t+1) + gamma Q(S_(t+1), A_(t+1))$]

  - *_Q-learning_*: #h(2.55cm) #text(fill:blue)[$R_(t+1) + gamma "max"_a Q(S_(t+1), a)$]

]


// *****************************************************************************

#slide(title: [_Q-learning_ _vs._ SARSA])[

  #let a = text(size: 20pt, fill: olive)[$a_t ~ b$]
  #let b = text(size: 20pt, fill: blue)[$a_t ~ pi$]

  #align(center)[

    *SARSA* #emoji.arrow.r #text(fill:olive)[$bold(a_t)$] se obtiene de la política de comportamiento.

    $ Q(S_t, A_t) <- Q(S_t, A_t) + alpha[ R_(t+1) + gamma Q(S_(t+1), underbracket(A_(t+1), #a)) - Q(S_t, A_t) ] $

    #v(1cm)

    *_Q-learning_* #emoji.arrow.r #text(fill:blue)[$bold(a_t)$] se obtiene de la política objetivo.

    $
      Q(S_t, A_t) <- Q(S_t, A_t) + alpha[R_(t+1) + gamma #h(0.1cm) "max"_a Q(S_(t+1),  underbracket(a, #b)) - Q(S_t, A_t)]
    $

  ]
]

// *****************************************************************************

#slide(title: [_Q-learning_: control TD _off-policy_])[

  #align(center)[#image("images/q-learning.png")]

]

// *****************************************************************************

#slide(title: [_Q-learning_: control TD _off-policy_])[

  #align(center)[#image("images/q-learning-notes.png")]

]

// *****************************************************************************

#slide(title: [_Q-learning_: control TD _off-policy_])[

  La #stress[política de comportamiento] determina qué pares acción-estado se visitan y actualizan.

  - El único requisito para que el algoritmo converja es que se visiten y actualicen periódicamente todos los pares acción-estado.

  #framed[Es común representar $Q(s,a)$ de forma *tabular*.]

  - El algoritmo de _Q-learning_ actualiza esta tabla (_Q-table_) de forma iterativa en base a la experiencia generada.

  La #stress[política objetivo] es aquella que actúa de forma *_greedy_* con respecto a los _Q-values_ aproximados.
]

// *****************************************************************************

#slide(title: [_Q-learning_: control TD _off-policy_])[

  #align(center)[#image("images/q-learn.png")]

]

// *****************************************************************************

#slide(title: [Diagramas _backup_])[
  #align(center)[#image("images/q-learning-backup.png", width: 48%)]
]


// *****************************************************************************

#title-slide([_Expected SARSA_])

// *****************************************************************************

#slide(title: [_Expected SARSA_])[

  _Recapitulemos..._

  #v(1cm)

  - Regla de actualización de #stress[SARSA] (control TD _on-policy_):

    #grayed[$ Q(S_t, A_t) <- Q(S_t, A_t) + alpha[R_(t+1) + gamma Q(S_(t+1), A_(t+1)) - Q(S_t, A_t)] $]

  - Regla de actualización de #stress[_Q-learning_] (control TD _off-policy_):

    #grayed[$
        Q(S_t, A_t) <- Q(S_t, A_t) + alpha[R_t + gamma #h(0.1cm) "max"_a Q(S_(t+1), a) - Q(S_t, A_t)]
      $]

]


// *****************************************************************************

#slide(title: [_Expected SARSA_])[

  #stress[_Expected SARSA_] es una alternativa que utiliza la siguiente *regla de actualización*:

  #grayed[
    #set text(size: 22pt)
    $
      Q(S_t, A_t) &<- Q(S_t, A_t) + alpha[R_(t+1) + gamma EE_pi [Q(S_(t+1), A_(t+1) | S_(t+1)] - Q(S_t, A_t)] \
      &<- Q(S_t, A_t) + alpha[R_(t+1) + gamma colmath(sum_a pi(a|S_(t+1)) Q(S_(t+1), a)) - Q(S_t, A_t)]
    $
  ]

  Sigue un esquema similar al de _Q-learning_ pero, en vez utilizar el valor máximo para $Q(S_(t+1), A_(t+1))$, utiliza el #stress[valor esperado].

  #framed[_Expected SARSA_ emplea la suma de todos los posibles valores $Q(S_(t+1), A_(t+1))$ ponderados por la probabilidad de elección de $A_(t+1)$.]

]



// *****************************************************************************

#slide(title: "Comparativa")[

  #framed[_TD targets_ de los diferentes algoritmos vistos hasta el momento...]

  #v(1cm)

  - *SARSA*: #h(3.95cm) #text(fill:olive)[$R_(t+1) + gamma Q(S_(t+1), A_(t+1))$]

  - *_Q-learning_*: #h(2.55cm) #text(fill:blue)[$R_(t+1) + gamma "max"_a Q(S_(t+1), a)$]

  - *_Expected SARSA_*: #h(1cm) #text(fill:red)[$R_(t+1) + gamma sum_a pi(a|S_(t+1)) Q(S_(t+1), a)$]

]

// *****************************************************************************

#slide(title: "Comparativa")[

  *SARSA*: #h(3.95cm) #text(fill:olive)[$R_(t+1) + gamma bold(Q(S_(t+1), A_(t+1)))$]

  - Emplea como estimación el valor de un par $(S_(t+1), A_(t+1))$ elegido aleatoriamente por la política de comportamiento.

  *_Q-learning_*: #h(2.55cm) #text(fill:blue)[$R_(t+1) + gamma bold("max"_a Q(S_(t+1), a))$]

  - Emplea como estimación el valor del par ($S_(t+1), A_(t+1))$ con valor máximo, que sería el elegido por la política objetivo.

  *_Expected SARSA_*: #h(1cm) #text(fill:red)[$R_(t+1) + gamma bold(sum_a pi(a|S_(t+1)) Q(S_(t+1), a))$]

  - Emplea como estimación la suma de los valores de todos los pares $(S_(t+1), A_(t+1))$ alcanzables, ponderados por sus probabilidades.

]

// *****************************************************************************

#slide(title: [_Expected SARSA_])[

  _Expected SARSA_ es computacionalmente más complejo que SARSA, pero elimina la #stress[alta varianza] asociada a la selección aleatoria de $A_(t+1)$.

  - De esta forma, mejora el rendimiento _vs._ SARSA (en la mayoría de los casos).

  #framed[Puede utilizarse de forma #stress[_on-policy_] u #stress[_off-policy_], empleando una política de comportamiento diferente a $pi$.]

  - _Expected SARSA_ engloba a _Q-learning_ y mejora a SARSA, a cambio de cierto aumento del coste computacional (a medida que el número de acciones posibles crece).

  - Por lo general, _Expected SARSA_ *domina* al resto de algoritmos basados en TD.

]


// *****************************************************************************

#slide(title: [_Expected SARSA_ _vs._ SARSA])[
  #align(center)[
    #box(height: 450pt)[
      #image("images/sarsa-vs-expected.png", width: 75%)
      La #stress[actualización del _target_] en _Expected SARSA_ presenta una menor varianza.
    ]
  ]
]

// *****************************************************************************

#slide(title: [_Expected SARSA_ _vs._ _Q-learning_])[

  #let q = text(fill: blue, size: 30pt)[\ Q-learning]
  #box(height: 500pt)[

    La principal característica de _Expected SARSA_ es su forma de estimar _action-values_ en base a los valores esperados.

    Con respecto a su implementación, puede ser tanto *_on-policy_* como *_off-policy_*.

    - En el caso *_off-policy_*...

    - ¿Qué ocurre si la #stress[política objetivo] ($pi$) de _Expected SARSA_ es _greedy_ con respecto a los _action-values_ estimados?

    #columns(2, gutter: 1pt)[

      #align(center)[
        #table(
          columns: 5,
          inset: 10pt,
          fill: (x, y) => if x == 0 { gray.lighten(80%) } else if x == 3 { green.lighten(70%) },
          [$Q(S_(t+1), a')$], [-1.7], [0], [*4.6*], [2.4],
          [$pi(a'|S_(t+1))$], [0], [0], [*1*], [0],
        )
      ]
      #colbreak()


      $sum_a pi(a|S_(t+1)) Q(S_(t+1), a) = underbrace("max"_a Q(S_(t+1), a), bold(#q))$

    ]
    #align(center)[#framed[#emoji.checkmark.box Vemos que *_Q-learning_ es un caso especial de _Expected SARSA_.*]]

  ]

]

// *****************************************************************************

#slide(title: [Comparativa de diagramas _backup_])[
  #align(center)[#image("images/backups.png", width: 65%)]
]


// *****************************************************************************

#title-slide([Control _n-step_])


// *****************************************************************************

#slide(title: [_n-step_ SARSA])[
  Como vimos en el caso de TD, es posible extender los métodos de control vistos a escenarios *_n-step_*.

  En el caso de #stress[_n-step_ SARSA], el retorno _n-step_ sería:

  #grayed[
    $ G_(t:t+n) = R_(t+1) + gamma R_(t+2) + dots + gamma^(n-1) R_(t+n) + gamma^n Q_(t+n-1) (S_(t+n), A_(t+n)) $
  ]

  Lo que da lugar a la siguiente *actualización* de los _action-values_:

  #grayed[
    $ Q_(t+n)(S_t, A_t) = Q_(t+n-1) (S_t, A_t) + alpha[G_(t:t+n) - Q_(t+n-1)(S_t,A_t)] $
  ]

]


// *****************************************************************************

#slide(title: [_n-step_ SARSA])[
  #align(center)[
    #image("images/n-step-sarsa.png")]

]

// *****************************************************************************

#slide(title: [_n-step_ SARSA])[
  #align(center)[#box(height: 420pt)[
      #image("images/n-step-sarsa-algo.png")]
  ]
]


// *****************************************************************************

#slide(title: [Ejemplo])[
  #box(height: 450pt)[

    En este ejemplo comparamos el número de _action-values_ que se habrán reforzado al final de un episodio empleando *_1-step SARSA_* y *_10-step SARSA_*.

    #image("images/example-sarsa.png")

    El método _1-step_ refuerza sólo la última acción de la secuencia de acciones que condujeron a $G$, mientras que el método _n-step_ ($n=10$) refuerza las últimas $n$ acciones de la secuencia, por lo que se aprende mucho más en un solo episodio.
  ]
]


// *****************************************************************************

#slide(title: [Métdos _n-step_ _off-policy_])[


  En el caso de los métodos _n-step_ #stress[off-policy], tenemos:

  #grayed[$
      Q_(t+n) (S_t, A_t) = Q_(t+n-1) (S_t, A_t) + alpha rho_(t+1:t+n) [ G_(t:t+n) - Q_(t+n-1) (S_t, A_t) ]
    $]

  Donde el _importance sampling ratio_ es:

  #grayed[$rho_(t:h) product^("min"(h,T-1))_(k=t) pi(A_k|S_k) / b(A_k|S_k)$]

]


// *****************************************************************************

#slide(title: [Métdos _n-step_ _off-policy_])[
  #align(center)[#box(height: 420pt)[
      #image("images/n-step-off.png")
    ]]
]


// *****************************************************************************

#focus-slide[Hablando en código...]

// *****************************************************************************

#slide(title: [SARSA])[
  #align(center)[

    #text(size: 18pt)[
      ```python
      class SARSA:

        def __init__(self, env, alpha=.1, gamma=1, epsilon=.1):

            self.env = env

            self.alpha = alpha
            self.gamma = gamma
            self.epsilon = epsilon

            self.actions = ['up', 'down', 'left', 'right']

            self.q_table = {
                (x, y): {action: 0 for action in self.actions}
                for x in range(self.env.height) for y in range(self.env.width)
            }

            self.total_rewards = []
      ```
    ]

  ]
]

// *****************************************************************************

#slide(title: [SARSA])[
  #align(center)[
    #box(height: 500pt)[
      #text(size: 18pt)[
        ```python
        def get_action(self, state):
            '''Returns a sampled action according to E-greedy policy'''

            if np.random.uniform(0, 1) < self.epsilon:
                return np.random.choice(self.actions)
            else:
                x, y = state
                state_actions = self.q_table[(x, y)]
                max_value = max(state_actions.values())
                max_actions = [action for action,
                               value in state_actions.items() if value == max_value]
                return np.random.choice(max_actions)

        def update_q_value(self, s, a, r, s_next, a_next):
            '''Applies the SARSA update rule for state-action values'''

            td_target = r + self.gamma * self.q_table[s_next][a_next]
            td_error = td_target - self.q_table[s][a]
            self.q_table[s][a] += self.alpha * td_error
        ```
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: [Q-learning])[
  #align(center)[
    #box(height: 500pt)[
      #text(size: 19pt)[
        ```python
        def update_q_value(self, s, a, r, s_next):
            '''
            Applies the Q-learning update rule for state-action values
            '''
            max_q_next = max(self.q_table[s_next].values())

            td_target = r + self.gamma * max_q_next
            td_error = td_target - self.q_table[s][a]
            self.q_table[s][a] += self.alpha * td_error
        ```
      ]
    ]
  ]
]


// *****************************************************************************

#slide(title: [Expected SARSA])[
  #align(center)[
    #box(height: 500pt)[
      #text(size: 19pt)[
        ```python
        def update_q_value(self, s, a, r, s_next):
            '''
            Applies the Expected SARSA update rule for state-action values
            '''
            expected_q_next = np.mean([self.q_table[s_next][action]
                                      for action in self.actions])

            td_target = r + self.gamma * expected_q_next
            td_error = td_target - self.q_table[s][a]
            self.q_table[s][a] += self.alpha * td_error
        ```
      ]
    ]
  ]
]

// *****************************************************************************

#title-slide("Trabajo propuesto")

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  #box(height: 500pt)[
    #text(size: 17pt)[

      - Probar los #stress[algoritmos] vistos (_trata de hacer tu propia implementación_):

        #text(size: 16pt)[
          - #link("https://github.com/manjavacas/rl-temario/tree/main/codigo/cliff_walking")
        ]

        #text(size: 16pt)[
          - #link("https://github.com/manjavacas/rl-temario/tree/main/codigo/montecarlo")
        ]


      - Comparativa de *Monte Carlo*, *SARSA*, *_Q-learning_* y *_Expected SARSA_* para un mismo problema, variando los diferentes parámetros (ej. $alpha$, $gamma$).

        - Pruébalos en un entorno de Gymnasium.

      *Bibliografía y webs recomendadas*

      #text(size: 14pt)[
        - *Capítulos 6 y 7* de Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction.
        - *Capítulo 6* de Morales, M. (2020). Grokking deep reinforcement learning. Manning Publications.
        - https://www.youtube.com/watch?v=bpUszPiWM7o
        - https://www.youtube.com/watch?v=AJiG3ykOxmY
        - https://www.youtube.com/watch?v=0g4j2k_Ggc4
        - https://www.youtube.com/watch?v=0iqz4tcKN58
        - https://www.youtube.com/watch?v=C3p2wI4RAi8
        - https://www.statlect.com/asymptotic-theory/importance-sampling
      ]
    ]
  ]
]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: [Métodos basados en muestreo: _TD-learning_],
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)
