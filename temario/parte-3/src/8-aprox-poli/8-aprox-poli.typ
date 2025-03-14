#import "@preview/typslides:1.2.5": *

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

#slide(title: [Aproximación de políticas])[

  Los métodos basados en *gradiente de la política* se basan en el uso de una #stress[política parametrizada], tal que:

  #grayed[$pi(a|s, bold(theta))$]

  #emoji.warning Es necesario que $pi_bold(theta)$ sea diferenciable con respecto a $bold(theta)$.

  En la práctica, para garantizar la *exploración*, se necesita que la política nunca sea determinista, es decir:

  #grayed[$ pi(a|s, bold(theta)) in (0, 1) #h(.5cm) forall s,a,bold(theta) $]

]

// *****************************************************************************

#slide(title: [Políticas parametrizadas _soft-max_])[

  Si el espacio de acciones es discreto y no demasiado grande, una forma común de parametrización es establecer *preferencias numéricas* $h(s,a,bold(theta)) in RR$ para cada par acción-estado.

  - A mayor preferencia, mayor probabilidad de elegir una acción.
  - Por ejemplo, podemos utilizar #stress[soft-max] sobre estas preferencias (_soft-max action preferences_):

  $ pi(a|s,bold(theta)) = (e^h(s,a,bold(theta))) / (sum_b e^h(s,b,bold(theta))) $

  - La parametrización de las preferencias pueden venir dadas por los pesos de una *red neuronal* (ej. AlphaGo) o por características lineales (_linear features_):

  $ h(s,a,bold(theta)) = bold(theta)^T bold(x)(s,a) #h(.5cm) bold(x)(s,a) in RR^d' $

]

// *****************************************************************************

#slide(title: [Políticas parametrizadas _soft-max_])[

  #grayed[
    $
      pi(a|s,bold(theta)) = overbrace(e^h(s,a,bold(theta)),"Preferencia por acción") / underbrace(sum_(b in cal(A)) e^(h(s,b,bold(theta))), "Preferencia por el resto de acciones")
    $
  ]
  - Se emplea $e^x$ para que siempre se obtenga un valor positivo.
  - El denominador normaliza el resultado para que la suma de probabilidades sea $1$.

  Debemos distinguir entre *preferencias de acción* y *valores de acción*:


]

// *****************************************************************************

#slide(title: [Valor _vs._ preferencia])[

  #figure(image("images/preferences.png", width: 60%))

]

// *****************************************************************************

#slide(title: [Políticas parametrizadas _soft-max_ _vs._ $bold(epsilon)$-_greedy_ ])[

  Ventaja de emplear políticas parametrizadas + _soft-max_ frente a $epsilon$-_greedy_:

  - Con $epsilon$-_greedy_ siempre existe cierta capacidad de explorar, a menos que el valor de $epsilon$ se reduzca con el tiempo.

  - Si empleamos _soft-max_ con preferencias de acción, las probabilidades se asignan de modo que, si una acción es mucho mejor, su preferencia crece sin límite.

  #framed[Esto permite que, si realmente hay una mejor acción, la política sea *prácticamente determinista*.]

]

// *****************************************************************************

#slide(title: [Políticas estocásticas])[

  #framed[Otra ventaja de las políticas parametrizadas basadas en preferencias _soft-max_ es que *permiten la selección de acciones con probabilidades arbitrarias*. Es decir, permiten aprender #stress[políticas estocásticas óptimas.]]

  - Útil en problemas donde, en un mismo estado, dos acciones pueden ser viables con diferente probabilidad.

    - Por ejemplo, juegos de cartas parcialmente observables donde jugar de forma óptima requiere en ocasiones actuar de forma diferente con probabilidades específicas (ej. jugar de farol en Poker).

  - Los métodos basados en _action values_ no tienen una forma natural de converger en políticas estocásticas óptimas.

]

// *****************************************************************************

#slide(title: [Políticas parametrizadas _soft-max_])[

  #framed[Quizá la mayor y más simple ventaja de las políticas parametrizadas es que *generalmente son funciones más simples de aproximar que las funciones de valor*.]

  - Aunque siempre dependerá del problema abordado, es común que esto se cumpla.

  #framed[También es posible incluir cierto *conocimiento experto* en el sistema a partir de la elección de los parámetros de la política.]

  - Esto no ocurre si el ajuste de dichos parámetros es automático (ej. red neuronal).

]

// *****************************************************************************

#slide(title: [Actualización de la política])[

  Finalmente, las políticas parametrizadas ofrecen una importante *ventaja teórica*:

  - La #stress[parametrización de la política] supone *cambios suaves* en las probabilidades de las acciones durante el aprendizaje.

  - Por el contrario, la #stress[aproximación de funciones de valor + $bold(epsilon)$-_greedy_], hace que las probabilidades de las acciones cambien de forma *drástica* dada una variación menor en el valor estimado de pares acciones-estado.

  Esto será especialmente relevante a la hora de aplicar *ascenso del gradiente* para optimizar $bold(theta)$.

]

// *****************************************************************************

#slide(title: [Actualización de la política])[

  #image("images/policy_upgrades.png")

]

// *****************************************************************************

#title-slide[Teorema del gradiente de la política]

// *****************************************************************************

#slide(title: [Rendimiento de una política])[

  Al contrario que en los métodos basados en funciones de valor, donde buscábamos minimizar un error de estimación, en los métodos basados en políticas buscamos *maximizar el rendimiento*.

  - Una *política óptima* será aquella que maximice $v_pi_bold(theta)$, es decir, la función estado-valor real de $pi_bold(theta)$.

  - En el caso *episódico*, nuestra métrica de #stress[rendimiento] puede expresarse como:

  #grayed[$J(bold(theta)) &= v_pi_bold(theta) (s_0)\
      &= EE_pi_bold(theta)[G_t | S_t = s_0]\
      &= EE_pi_bold(theta)[sum^infinity_(k=0) R_(t+k+1) | S_t = s_0]$
  ]

]

// *****************************************************************************

#slide(title: [Rendimiento de una política])[

  La política parametrizada por $bold(theta)$ se optimiza a medida que los valores de $bold(theta)$ dan lugar a un mejor rendimiento.

  - Actualización basada en *ascenso del gradiente*.

  #figure(image("images/theta_updates.png"))

  $ theta_(t+1) = theta_t + alpha hat(gradient J(theta_t)) $

]

// *****************************************************************************

// #slide(title: [Teorema del gradiente de la política])[

//   Pero, ¿cómo calculamos el gradiente de $J(bold(theta))?$

//   La respuesta viene dada por el #stress[teorema del gradiente de la política] (_policy gradient theorem_):

//   #grayed[
//     $ gradient J(bold(theta)) prop sum_s mu(s) sum_a q_pi_theta (s,a) gradient pi_theta(a|s,bold(theta)) $
//   ]

//   - Recordemos que $mu(s)$ es la frecuencia de visita de $s$ bajo $pi_bold(theta)$ (fracción de tiempo invertido en $s$).

// ]

// *****************************************************************************

#slide(title: [Gradiente de $J(bold(theta))$])[

  // #grayed[$J(bold(theta)) = v_pi_bold(theta) (s_0)$]

  #grayed[Optimizar de $J(bold(theta))$ requiere calcular el gradiente $gradient_theta J(bold(theta))$]

  Debemos tener en cuenta que el rendimiento depende de:

  1. Las #stress[acciones elegidas] $->$ directamente determinadas por $pi_bold(theta)$

  2. La #stress[secuencia de estados visitados] $->$ influenciada tanto por $pi_bold(theta)$ como por las *dinámicas del entorno* $p(s'|s,a)$.

  - Nuestro problema es que las dinámicas del entorno *están fuera de la capacidad de control del agente*.

]

// *****************************************************************************

#slide(title: [Gradiente $J(bold(theta))$])[

  #figure(image("images/dynamics.png"))

]

// *****************************************************************************

#slide(title: [Gradiente de $J(bold(theta))$])[

  - Dado un estado, es relativamente sencillo calcular cómo afectan los parámetros de la política a la #stress[elección de la acción] y, por tanto, a la recompensa obtenida.

  - Sin embargo, el efecto de la política sobre la #stress[distribución de estados] (es decir, qué estados se visitarán) es algo que también depende del entorno y es, generalmente, desconocido.#footnote[Andriy Drozdyuk expresa esto con el ejempo: "las dinámicas de una roca no dependen de quién la levanta".]

  #framed[#emoji.quest ¿Cómo podemos estimar la dirección del gradiente y *mejorar la política* cuando parte de ese gradiente depende de un *efecto desconocido* sobre la distribución de estados?]

]

// *****************************************************************************

#slide(title: [Teorema del gradiente de la política])[

  La solución se encuentra en el #stress[teorema del gradiente de la política] (_policy gradient theorem_).

  - Gradiente de $J(bold(theta))$ en problemas episódicos:

  #grayed[
    $ gradient_theta J(bold(theta)) prop sum_s mu(s) sum_a q_pi_theta (s,a) gradient_theta pi_theta (a|s,bold(theta)) $
  ]

  Éste ofrece una definición del gradiente del rendimiento con respecto a $bold(theta)$ sin necesidad de tener en cuenta la derivada de la distribución de estados.

]

// *****************************************************************************

#slide(title: [Teorema del gradiente de la política])[

  #grayed[
    $ gradient_theta J(bold(theta)) prop sum_s mu(s) sum_a q_pi_theta (s,a) gradient_theta pi_theta (a|s,bold(theta)) $
  ]

  - Los gradientes son vectores columna de las derivadas parciales con respecto a los componentes de $bold(theta)$.

  - $pi$ es la política asociada al vector de parámetros $bold(theta)$.

  - $prop$ denota propocionalidad. En problemas #stress[episódicos], la constante de proporcionalidad es la longitud media del episodio, mientras que en problemas #stress[continuados] es 1 (la relación pasa a ser de igualdad).

  - La distribución $mu$ es la distribución _on-policy_ bajo $pi_theta$. Representa la fracción de tiempo invertido en un determinado estado.

]

// *****************************************************************************

#slide(title: [Teorema del gradiente de la política])[

  #align(center)[#framed[¿Qué nos indica el teorema del gradiente de la política?]]

  #grayed[
    $ gradient_theta J(bold(theta)) prop sum_s mu(s) sum_a q_pi_theta (s,a) gradient_theta pi_theta (a|s,bold(theta)) $
  ]

  1. Que la actualización de $bold(theta)$ (es decir, el gradiente de $J(bold(theta))$) es proporcional a la suma de los gradientes de la política ponderados por los valores de acción.

  2. Que no se requiere calcular ningún gradiente relacionado con las dinámicas del entorno (no se depende de $gradient mu(s)$).

]

// *****************************************************************************

#slide(title: [Teorema del gradiente de la política])[

  #set text(size: 30pt)

  #let explanation = [Mejorar el rendimiento\ de la política implica\ ajustar los parámetros\ de tal forma que las acciones\ más valiosas sean más probables]

  $
    gradient_theta J(bold(theta)) prop sum_s mu(s) underbrace(sum_a q_pi_theta (s,a) gradient_theta pi_theta (a|s,bold(theta)), #explanation)
  $

]

// *****************************************************************************

#focus-slide("Demostración del teorema")

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[


  #framed[#emoji.warning Para simplificar la notación, de aquí en adelante expresaremos $gradient_bold(theta)$ como $gradient$, y $pi_bold(theta)$ como $pi$.]

  Partimos de la relación entre $v_pi (s)$ y $q_pi (s,a)$:

  #let a = [Suma ponderada/ \ valor esperado]
  #v(.5cm)
  #cols[
    #grayed[
      $
        v_pi (s) &= EE_pi [q_pi (s,a)]\
        &= underbrace(sum_a pi(a|s) q_pi (s,a), #a)
      $
    ]][
    #figure(image("images/v_q.png"))
  ]

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  Si incluimos el gradiente, tenemos:

  #grayed[
    $ gradient v_pi (s) = gradient [sum_a pi(a|s) q_pi (s,a)] #h(.3cm) forall s in cal(S) $
  ]

  - Estamos expresando el gradiente de la *función de valor de estado* en términos de la *función de valor acción-estado*.

]


// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  Si aplicamos la regla del producto de gradientes, obtenemos:

  #grayed[
    $
      gradient v_pi (s) &= gradient [sum_a pi(a|s) q_pi (s,a)] #h(.3cm) \
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) gradient q_pi (s,a)]
    $
  ]

  - Regla del producto de gradientes:

  $ gradient (f(x) g(x)) = gradient f(x) g(x) + f(x) gradient g(x) $

  - El sumatorio se puede extraer: $gradient sum f(x) = sum gradient f(x)$.

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[


  Expandimos el siguiente término:

  #grayed[
    $
      gradient v_pi (s)
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) gradient colmath(q_pi (s,a))]
    $
  ]

  Y obtenemos:

  #grayed[
    $
      gradient v_pi (s)
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) gradient colmath(sum_(s',r) p(s',r|s,a)(r+v_pi (s')))]
    $
  ]
]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  #grayed[
    $
      gradient v_pi (s)
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) gradient sum_(s',r) p(s',r|s,a)(r+v_pi (s'))]
    $
  ]

  El valor $q(s,a)$ se expresa en términos de recompensa esperada.

  #figure(image("images/q_expand.png"))
]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  A continuación, buscamos eliminar las recompensas de $sum_(s',r)$

  Para ello, tratamos de volver a comprimir esta parte de la ecuación:

  #grayed[
    #set text(size: 21pt)
    $
      gradient v_pi (s)
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) gradient sum_(s',r) p(s',r|s,a)(r+v_pi (s'))]\
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) gradient colmath(sum_s' sum_r p(s',r|s,a)(r+v_pi (s')))]\
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) gradient colmath(sum_s' sum_r p(s',r|s,a)r + p(s',r|s,a)v_pi (s'))]
    $
  ]

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  - Simplificamos $p(s',r|s,a)$ como $rho$.

  Aplicando la regla del producto tenemos:

  #grayed[
    #set text(size: 20pt)
    $
      gradient v_pi (s)
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) gradient sum_s' sum_r rho r + rho v_pi (s')]\
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) colmath(sum_s' sum_r gradient rho r + rho gradient r + gradient rho v_pi (s') + rho gradient v_pi (s'))]
    $
  ]

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  Los términos con gradiente $0$ con respecto a $bold(theta)$ se anulan:

  #grayed[
    #set text(size: 20pt)
    $
      gradient v_pi (s)
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) colmath(sum_s' sum_r cancel(gradient rho r) + cancel(rho gradient r) + cancel(gradient rho v_pi (s')) + rho gradient v_pi (s'))]
    $
  ]

  - Ya que $gradient_bold(theta) #h(.1cm) r = 0$ y $gradient_bold(theta) #h(.1cm) p(s',r|s,a) = 0$

  Finalmente obtenemos:

  #grayed[
    #set text(size: 20pt)
    $
      gradient v_pi (s)
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) colmath(sum_s' sum_r + p(s',r|s,a) gradient v_pi (s'))]
    $
  ]

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  Si reorganizamos la ecuación:

  #grayed[
    $
      gradient v_pi (s)
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) sum_s' gradient v_pi (s') colmath(sum_r p(s',r|s,a))]
    $
  ]

  - Para eliminar $sum_r$, reducimos $sum_r p(s',r|s,a)$ (expectación en términos de recompensa) a una expresión más general:

  - Dado que: $p(s'|s,a) = Pr{S_t = s' | S_(t-1) = s, A_(t-1) = a} = sum_(r in cal(R)) p(s',r|s,a)$

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  De esta forma, tenemos:

  #grayed[
    $
      gradient v_pi (s)
      &= sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) colmath(sum_s' p(s'|s,a) gradient v_pi (s'))]
    $
  ]

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  Ahora, sustituimos $gradient v_pi (s')$ por su definición (_unrolling_):

  #grayed[
    #set text(size: 22pt)
    $
      #h(-1cm) gradient v_pi (s)
    = sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) sum_s' p(s'|s,a) colmath(gradient v_pi (s'))]\
    #h(-5cm)  = sum_a [gradient pi(a|s) q_pi (s,a) + pi(a|s) sum_s' p(s'|s,a) \ #h(2cm) colmath(sum_a' gradient pi(a'|s') q_pi (s',a') + pi(a'|s') sum_s'' p(s''|s',a') gradient v_pi (s''))]
    $
  ]

  Podemos aplicar este _unrolling_ de forma continuada.

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  Finalmente, resumimos la expresión obtenida como:

  #grayed[
    $ gradient v_pi (s) = sum_(x in cal(S)) sum_(k=0)^infinity Pr(s->x, k, pi) sum_a gradient pi(a|x) q_pi (x,a) $
  ]

  - $Pr(s->x, k, pi)$ es la probabilidad de transición desde el estado $s$ al estado $x$ en $k$ _timesteps_ bajo la política $pi$.

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  Bajo estas premisas, podemos demostrar el #stress[teorema del gradiente de la política].

  Si partimos de:

  #grayed[
    $ gradient J(bold(theta)) = gradient v_pi (s_0) $
  ]

  ...y sustituimos por la fórmula obtenida previamente, tenemos que:

  #grayed[
    $ gradient J(bold(theta)) = sum_s (sum_(k=0)^infinity Pr(s_0 -> s, k, pi)) sum_a gradient pi(a|s)q_pi (s,a) $
  ]

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  Comprimimos la probabilidad de transición en el término $eta(s)$ y normalizamos para que sea una distribución de probabilidad:

  #grayed[
    #set text(size: 26pt)
    $
      gradient J(bold(theta)) &= sum_s (sum_(k=0)^infinity Pr(s_0 -> s, k, pi)) sum_a gradient pi(a|s)q_pi (s,a)\
      &= sum_s colmath(eta(s)) sum_a gradient pi(a|s)q_pi (s,a)\
      &= colmath((sum_s' eta(s')) sum_s (eta(s)) / (sum_s' eta(s'))) sum_a gradient pi(a|s)q_pi (s,a)
    $
  ]

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  Dado que $sum_s' eta(s')$ es una constante:

  #grayed[
    #set text(size: 26pt)
    $
      gradient J(bold(theta)) &= colmath((sum_s' eta(s'))) sum_s eta(s) / (sum_s' eta(s')) sum_a gradient pi(a|s)q_pi (s,a)\
      colmath(&prop) sum_s (eta(s)) / (sum_s' eta(s')) sum_a gradient pi(a|s)q_pi (s,a)
    $
  ]

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  - La distribución $mu(s) = eta(s) / (sum_s' eta(s'))$ es la distribución _on-policy_ bajo $pi$ (tiempo invertido en el estado $s$ bajo la política $pi$).

  Teniendo esto en cuenta, obtenemos finalmente que:

  #grayed[
    #set text(size: 26pt)
    $
      gradient J(bold(theta))
      &prop sum_s colmath(mu(s)) sum_a gradient pi(a|s)q_pi (s,a)
    $
  ]


  Esta expresión permite obtener el gradiente del rendimiento con respecto a los parámetros de la política (es decir, $gradient_bold(theta) J(bold(theta))$) sin necesidad de calcular la derivada de la distribución de estados.

  - Veamos ahora cómo aplicarlo...

]


// *****************************************************************************

#title-slide([REINFORCE:\ gradiente de la política Monte Carlo])

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  -
  -

  #text(size: 24pt)[*Bibliografía y vídeos*]

  - #link("https://github.com/MathFoundationRL/Book-Mathematical-Foundation-of-Reinforcement-Learning")
  - #link("https://www.youtube.com/watch?v=e20EY4tFC_Q")
  - #link("https://www.youtube.com/watch?v=AiFM6LZ7Vuo")
  - #link("https://lilianweng.github.io/posts/2018-04-08-policy-gradient/")
]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Aproximación de políticas",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)
