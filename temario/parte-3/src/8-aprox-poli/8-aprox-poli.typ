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

// #title-slide("Políticas parametrizadas")

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

  // #set text(size: 17pt)
  // - Si el método empleado usa además una función de valor aproximada, entonces volveremos a contar con el vector de pesos $bold(w) in RR^d$ y $hat(v)(s, bold(w))$.

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

// #slide(title: [Métodos actor-crítico])[

//   También veremos métodos que aproximan la *política* y la *función de valor* al mismo tiempo.

//   Estos se denominan #stress[actor-crítico] (_actor-critic_), donde:

//   - El *actor* es la política aprendida.

//   - El *crítico* es la función de valor aproximada (normalmente, estado-valor).
// ]

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

#slide(title: [Valor _vs._ preferencia])[

  #framed(
    title: "Valor",
  )[Estimación de cuán bueno es un estado/acción en términos de la recompensa esperada a largo plazo.]

  #framed(title: "Preferencia")[Medida de cuánto prefiere el agente una acción sobre otra bajo su política actual. ]

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

  #grayed[$J(bold(theta)) &= v_pi_bold(theta) (s_0)$]

  Esta formulación representa el rendimiento como la expectación de la recompensa total obtenida a partir de un estado inicial $s_0$.

  - También puede expresarse como la recompensa esperada dada una trayectoria $tau$:

  #grayed[
    $J(bold(theta)) = EE_pi_bold(theta) [r(tau)]$
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

  Éste ofrece una definición del gradiente del rendimiento con respecto a $bold(theta)$ *sin necesidad de tener en cuenta la derivada de la distribución de estados visitados* empleando $pi_bold(theta)$.

  - Es decir, calcular $gradient_bold(theta) J(bold(theta))$ sin necesidad de calcular $sum_s gradient_bold(theta) mu(s)$.

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

  Teniendo esto en cuenta, obtenemos que:

  #grayed[
    #set text(size: 26pt)
    $
      gradient J(bold(theta))
      &prop sum_s colmath(mu(s)) sum_a gradient pi(a|s)q_pi (s,a)
    $
  ]

  Esta expresión permite obtener el gradiente del rendimiento con respecto a los parámetros de la política (es decir, $gradient_bold(theta) J(bold(theta))$) sin necesidad de calcular la derivada de la distribución de estados.

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  Finalmente, podemos reordenar la expresión y escribirla en términos de *valor esperado*, obteniendo:

  #grayed[
    #set text(size: 26pt)
    $
      gradient J(bold(theta))
      &prop sum_s mu(s) sum_a q_pi (s,a) gradient pi(a|s)\
      &= EE_pi [sum_a q_pi (S_t,a) gradient pi(a|S_t)]
    $
  ]

]

// *****************************************************************************

#slide(title: [Demostración del teorema del grandiente de la política])[

  #grayed[
    #set text(size: 26pt)
    $
      gradient J(bold(theta))
      prop EE_pi [sum_a q_pi (S_t,a) gradient pi(a|S_t)]
    $
  ]

  #framed(
    title: "Teorema del gradiente de la política",
  )[*El gradiente del rendimiento con respecto a los parámetros de la política* $gradient_bold(theta) J(bold(theta))$ es proporcional al *valor esperado de los gradientes de la política* $pi_bold(theta)$ ponderados por los *valores de acción* $q_pi_bold(theta) (s,a)$.]

  Una vez introducido el teorema, veamos cómo aplicarlo para obtener *políticas óptimas*...

]

// *****************************************************************************

#title-slide([REINFORCE])

// *****************************************************************************

#slide(title: [REINFORCE])[

  #framed[#stress[REINFORCE]#footnote[_*RE* eward *I* ncrement = *N* onnegative *F* actor $times$ *O* ffset *R* einforcement $times$ *C* haracteristic *E* ligibility_], o *_gradiente de la política Monte Carlo_*, es un algoritmo clásico basado en el gradiente de la política #footnote[#emoji.books _Williams, R. J. (1992). Simple statistical gradient-following algorithms for connectionist reinforcement learning. Machine learning, 8, 229-256._].]

  - Es de tipo #stress[Monte Carlo], ya que actualiza los parámetros de la política basándose en el retorno obtenido al final de cada episodio.

  // #cols[
  //   - Partiendo del teorema: #grayed[#text(size:18pt)[$gradient J(bold(theta))
  //     prop EE_pi [sum_a q_pi (S_t,a) gradient pi(a|S_t)]$]]
  // ][
  //   - Empleamos la #stress[regla de actualización]:#grayed[ #text(size:18pt)[ $bold(theta) <- bold(theta) + alpha sum_a hat(q)(S_t,a,bold(w)) gradient pi (a | S_t, bold(theta))$]]
  // ]

  #figure(image("images/trajectory.png", width: 60%))

]

// *****************************************************************************

#slide(title: [REINFORCE])[

  Partimos de la formulación del *teorema del gradiente de la política*:

  #grayed[
    $
      gradient J(bold(theta)) = EE_pi [sum_a gradient pi(a|S_t, bold(theta)) q_pi (S_t,a) ]
    $
  ]

  Multiplicamos y dividimos por $pi(a|S_t, bold(theta))$:

  #grayed[
    $
      gradient J(bold(theta)) = EE_pi [sum_a gradient pi(a|S_t, bold(theta)) q_pi (S_t,a) (pi(a|S_t, bold(theta))) / (pi(a|S_t, bold(theta))) ]
    $
  ]

]

// *****************************************************************************

#slide(title: [REINFORCE])[

  Si reorganizamos la expresión, tenemos:

  #grayed[
    $
      gradient J(bold(theta)) = EE_pi [sum_a pi(a|S_t, bold(theta)) q_pi (S_t,a) (gradient pi(a|S_t, bold(theta))) / (pi(a|S_t, bold(theta))) ]
    $
  ]

  Después, reemplazamos $a$ por $A_t tilde pi$:

  #grayed[
    $
      gradient J(bold(theta)) = EE_pi [q_pi (S_t, A_t) (gradient pi(A_t|S_t, bold(theta))) / (pi(A_t|S_t, bold(theta))) ]
    $
  ]

]

// *****************************************************************************

#slide(title: [REINFORCE])[

  Dado que $q_pi (S_t, A_t) = EE_pi [G_t | S_t, A_t]$, finalmente obtenemos:

  #grayed[
    $
      gradient J(bold(theta)) = EE_pi [G_t (gradient pi(A_t|S_t, bold(theta))) / (pi(A_t|S_t, bold(theta)))]
    $
  ]

  Donde:

  - $G_t$ es el retorno obtenido#footnote[*REINFORCE es un algoritmo de tipo Monte Carlo* porque actualiza los parámetros de la política basándose en el retorno obtenido al final de cada episodio.].

  - La expresión $G_t (gradient pi(A_t|S_t, bold(theta))) / (pi(A_t|S_t, bold(theta)))$ es una cantidad que puede ser muestreada en cada _timestep_, cuyo valor esperado es igual al gradiente.

]

// *****************************************************************************

#slide(title: [REINFORCE: regla de actualización])[

  A partir de esta fórmula obtenemos la #stress[regla de actualización] de $bold(theta)$ empleada por REINFORCE:

  #grayed[
    $
      bold(theta)_(t+1) = bold(theta)_t + alpha G_t (gradient pi(A_t|S_t, bold(theta)_t)) / (pi(A_t|S_t, bold(theta)_t))
    $
  ]

  Su interpretación es intuitiva:

  - Cada incremento de $bold(theta)$ es proporcional a el *retorno acumulado* $G_t$ hasta el instante $t$, multiplicado por el *gradiente de la probabilidad de realizar * $A_t$ dividido por la *probabilidad de realizar* $A_t$.

  - El resultado es un *vector* que representa la dirección en el espacio de parámetros que más incrementa la probabilidad de repetir $A_t$ en futuras visitas a $S_t$.

]

// *****************************************************************************

#slide(title: [REINFORCE: regla de actualización])[

  #set text(size: 18pt)

  #framed[
    #emoji.thumb.up Si una acción lleva a una alta recompensa acumulada, su probabilidad aumentará en futuros epsiodios.

    #emoji.thumb.down Si el retorno obtenido es bajo, la acción se tomará con menor frecuencia.

    #emoji.arm Esto *refuerza* acciones buenas y reduce la probabilidad de realizar acciones potencialmente peores.
  ]

  Además, #stress[la actualización es proporcional a la probabilidad]:

  - *Acciones que ya eran probables no cambian tanto*. Esto evita que acciones seleccionadas con más frecuencia no tengan una ventaja injusta, ya que podrían predominar sin generar altos retornos.

  - *Acciones que eran improbables* pero resultaron en un alto $G_t$, se ven reforzadas significativamente.

]

// *****************************************************************************

#slide(title: [REINFORCE: regla de actualización compacta])[

  Una *forma alternativa* de expresar la regla de actualización de REINFORCE es la siguiente:

  #grayed[
    $
      bold(theta)_(t+1) = bold(theta)_t + alpha G_t gradient ln pi(A_t|S_t, bold(theta)_t)
    $
  ]


  La simplificación propuesta se debe a la igualdad:

  $ gradient ln x = (gradient x) / x $

  Esto permite una representación más compacta y facilita el cálculo del gradiente.

  #text(size: 16pt)[
    - Al vector $gradient ln pi(A_t|S_t, bold(theta)_t)$ se le suele denominar *vector de elegiblidad* (_eligibility vector_).
  ]

]

// *****************************************************************************

#slide(title: [REINFORCE])[

  #figure(image("images/reinforce.png"))

  - Se incluye el _factor de descuento_ $gamma$ para problemas con retorno descontado.

]

// *****************************************************************************

// #slide(title: [Otra posible formulación...])[

//   El *objetivo* de REINFORCE también puede expresarse como:

//   #grayed[
//     $gradient J(bold(theta)) prop EE_pi [q_pi (S_t, A_t) gradient pi (A_t|S_t, bold(theta))]$
//   ]

//   y la *regla de actualización* como:

//   #grayed[
//     $
//       bold(theta) <- bold(theta) + alpha q_pi (S_t, A_t) gradient ln pi(A_t|S_t, bold(theta))
//     $
//   ]

//   dado que $EE_pi [G_t | S_t, A_t] = q_pi (S_t, A_t)$.
// ]

// *****************************************************************************

#slide(title: [Convergencia y limitaciones de REINFORCE])[

  #framed[

    #emoji.checkmark.box REINFORCE ofrece garantías de #stress[convergencia] en óptimos locales en condiciones estocásticas de aproximación y descenso continuo de $alpha$.

    #emoji.crossmark No obstante, al tratarse de un método de tipo Monte Carlo, presenta un #stress[aprendizaje lento] y una #stress[alta varianza].

  ]

  Para abordar estas limitaciones, se proponen las variaciones de REINFORCE que estudiaremos a continuación.

]

// *****************************************************************************

#title-slide([Valores de referencia])

// *****************************************************************************

#slide(title: [Problemas de REINFORCE])[

  #framed[Los algoritmos que emplean el *retorno episódico* $G$, como #stress[REINFORCE], tienden a presentar una *alta varianza*.]

  #cols[

    - En este caso, la varianza se da en la actualización de los parámetros de la política, $bold(theta)$.

    - El gradiente se calcula a partir de la recompensa acumulada en un episodio completo, lo que introduce *grandes fluctuaciones* en la actualización de los parámetros.
  ][
    #figure(image("images/value_update.png", width: 80%))
  ]
]

// *****************************************************************************

#slide(title: [Problemas de REINFORCE])[

  - Además, la *variabilidad entre episodios* puede ser significativa, dificultando la convergencia del aprendizaje.

  #figure(image("images/variability.png", width: 80%))

]

// *****************************************************************************

#slide(title: [Problemas de REINFORCE])[

  #framed[
    #emoji.arrow.r La *acumulación de eventos aleatorios* a lo largo de las trayectorias ---incluyendo la *aleatoriedad del estado inicial*--- dan lugar a un retorno $G$ que puede variar significativamente de un episodio a otro.
  ]


]

// *****************************************************************************

#slide(title: [REINFORCE con _baseline_])[

  // El teorema del gradiente de la política permite incluir una comparación del valor de $q_pi_bold(theta) (s,a)$ con un *valor de referencia* (#stress[_baseline_]) arbitrario: $b(s)$.

  El teorema del gradiente de la política permite incluir una comparación del valor $G$ con un *valor de referencia* (#stress[_baseline_]) arbitrario: $b(s)$.

  - El #stress[valor de referencia] $b(s)$ puede ser cualquier valor o función, siempre que no dependa de la acción tomada $a$.

  // De esta forma, y dado que $EE_pi [G_t | S_t, A_t] = q_pi (S_t, A_t)$, tenemos:
  De esta forma, tenemos que:

  // #grayed[
  //   $
  //     gradient J(bold(theta)) prop sum_s mu(s) sum_a (colmath(q_pi (s,a) - b(s))) gradient pi(a|s,bold(theta))
  //   $
  // ]
  //
  #grayed[
    $
      gradient J(bold(theta)) prop sum_s mu(s) sum_a (colmath(G - b(s))) gradient pi(a|s,bold(theta))
    $
  ]

  - Dicho valor no afecta al gradiente, simplemente es una expectativa del valor real.
  - Si este valor se aproxima mínimamente al valor real de $s$, la varianza de la actualización de los parámetros se verá reducida.

]

// *****************************************************************************

#slide(title: [Regla de actualización de REINFORCE con _baseline_])[

  De esta forma, tenemos el algoritmo llamado #stress[REINFORCE con _baseline_], también denominado #stress[_Vanilla Policy Gradient_] (*VPG*), que emplea la siguiente #stress[regla de actualización]:

  #grayed[
    $
      bold(theta)_(t+1) = bold(theta)_t + alpha (colmath(G_t - b(S_t))) gradient ln pi(A_t|S_t, bold(theta)_t)
    $
  ]

  - Se trata de un caso más general que REINFORCE sin _baseline_, ya que si $b(s) = 0$, obtenemos la regla de actualización vista anteriormente.

]


// *****************************************************************************

#slide(title: [REINFORCE con _baseline_])[

  #cols[
    Emplear un #stress[_baseline_] permite incorporar una *estimación* del valor real que facilite la actualización de $bold(theta)$.

    - La *dirección* del gradiente se mantiene, ya que la resta de $b(s)$ no afecta a la dirección de la actualización.

    - La *convergencia* del algoritmo se ve favorecida, ya que la *varianza* de la actualización de los parámetros se reduce.
  ][
    #grayed[
      #set text(size: 15pt)
      $
        bold(theta)_(t+1) = bold(theta)_t + alpha (G_t - b(S_t)) gradient ln pi(A_t|S_t, bold(theta)_t)
      $
    ]
    #figure(image("images/with_baseline.png", width: 80%))
  ]
]

// *****************************************************************************

#focus-slide([¿Qué _baseline_ utilizar?])

// *****************************************************************************

#slide(title: [Elección del _baseline_])[

  #framed[Es común emplear como _baseline_ la estimación del #stress[estado-valor], $hat(v) (S_t, bold(w))$.]

  - Dado que que REINFORCE está basado en Monte Carlo, los pesos $bold(w)$ pueden estimarse *de la misma manera*, tal y como vimos en el tema anterior.

  De esta forma, REINFORCE empleando $hat(v)$ como _baseline_ se resume en:
  #grayed[
    #set align(left)
    #set text(size: 19pt)
    1. Generar episodio: $S_0, A_0, R_1, dots, S_(T-1), A_(T-1), R_T$ siguiendo $pi_bold(theta)$ \
    2. Para cada _timestep_ $t = 0, 1, dots, T-1$ del episodio:

      - Calcular $G = sum^T_(k=t+1) gamma^(k-t-1) R_k$
      - Restar el _baseline_: $delta = G - hat(v)(S_t, bold(w))$ \
      - Actualizar $bold(w), bold(theta)$
  ]
]

// *****************************************************************************

#slide(title: [REINFORCE con _baseline_])[

  #figure(image("images/reinforce_baseline.png"))

]

// *****************************************************************************

#slide(title: [Comparativa])[

  #figure(image("images/comparison.png"))

]

// *****************************************************************************

#slide(title: [Conclusiones])[

  - En resumen, #stress[REINFORCE con _baseline_], o #stress[VPG], es un método robusto basado en el teorema del gradiente de la política.

  - Decimos que es un método *_no-sesgado_*, porque la actualización de $bold(theta)$ se basa en #stress[retornos episódicos] $G$, obtenidos directamente a partir de la interacción con el entorno.

  - El único *sesgo* que presentan se encuentran la *función de valor aproximada* $hat(v)$ que empleamos como #stress[_baseline_], pero este sesgo es prácticamente nulo.

]

// *****************************************************************************

#title-slide([Métodos _actor-critic_])

// *****************************************************************************

#slide(title: [Métodos _actor-critic_])[

  #figure(image("images/AC.png"))

]

// *****************************************************************************

#slide(title: [Métodos _actor-critic_])[

  Todo algoritmo _actor-critic_ está compuesto por dos funciones con sus propios conjuntos de parámetros ($bold(theta), bold(w)$):

  #framed(
    title: "Actor",
  )[#emoji.beetle Aprende la política $pi(A_t | S_t, bold(theta))$ y muestrea las acciones a realizar.]

  #framed(
    title: [_Critic_ (_crítico_)],
  )[#emoji.beetle.lady Aprende una función de valor $hat(v)(S_t, bold(w))$, $hat(q)(S_t, A_t, bold(w))$ y estima cómo de buenas son las acciones realizadas por el actor.]
]

// *****************************************************************************

#slide(title: [_Actor-critic_ _vs._ REINFORCE con _baseline_])[

  #set text(size: 25pt)
  Si REINFORCE con _baseline_ aprende una *política* $pi_bold(theta)$ y utiliza una *función de valor aproximada* $hat(v)(S_t, bold(w))$ como _baseline_... #emoji.face.think

  #v(1cm)

  #set align(center)
  #framed[¿Por qué no se considera *_actor-critic_*?]
]

// *****************************************************************************

#slide(title: [_Actor-critic_ _vs._ REINFORCE con _baseline_])[

  - #stress[REINFORCE con _baseline_] es un algoritmo de tipo Monte Carlo, ya que requiere esperar *final* del episodio para evaluar el error.

  #grayed[$delta = G - hat(v)(S_t, bold(w))$]

  - #stress[Actor-critic] permite evaluar el error de forma online, convirtiéndolo en un algoritmo basado en TD, es decir, _bootstrapping_.

  #grayed[$delta = R_(t+1) + gamma hat(v)(S_(t+1), bold(w)) - hat(v)(S_t, bold(w))$]
]

// // *****************************************************************************

// #slide(title: [_Actor-critic_ _vs._ REINFORCE con _baseline_])[

//   #framed(title: [#emoji.books Morales, M. (2020). Grokking deep reinforcement learning.])[
//     #set text(size: 17pt)
//     (...) _according to one of the fathers of RL, Rich Sutton, policy-gradient methods approximate the gradient of the performance measure, whether or not they learn an approximate
//     value function. However, David Silver, one of the most prominent figures in DRL, and a former
//     student of Sutton, disagrees. He says that policy-based methods don’t additionally learn a
//     value function, only actor-critic methods do. But, Sutton further explains that only methods
//     that learn the value function using bootstrapping should be called actor-critic, because it’s
//     bootstrapping that adds bias to the value function, and thus makes it a “critic.” I like this distinction; therefore, REINFORCE and VPG, as presented in this book, aren’t considered actor-
//     critic methods. But beware of the lingo, it’s not consistent._
//   ]

// ]

// *****************************************************************************

#slide(title: [Métodos _actor-critic_])[

  #framed[Los métodos #stress[_actor-critic_] son una extensión de REINFORCE con _baseline_ que, en lugar de usar el retorno $G$, emplean #stress[_bootstrapping_].]

  - Es decir, en vez de esperar al final del episodio y utilizar el retorno real $G$ para actualizar $bold(theta)$, se emplea una *estimación* de este.

  - Es análogo a TD, Sarsa o _Q-learning_, donde sustituimos el retorno de episodios completos por *estimaciones _n_ pasos hacia delante* desde el estado actual.

]

// *****************************************************************************

#slide(title: [_One-step actor-critic_])[

  El ejemplo más básico de este tipo de algoritmos es #stress[_one-step actor-critic_], donde se sustituye el retorno $G_t$ (_full return_) por el _one-step return_:

  $ R_(t+1) + gamma hat(v)(S_(t+1), bold(w)) - hat(v)(S_t, bold(w)) $

  - De esta forma, la actualización de $bold(theta)$ es la siguiente:

  #grayed[
    $
      bold(theta)_(t+1)
      = bold(theta)_t + alpha (colmath(R_(t+1) + gamma hat(v)(S_(t+1), bold(w)) - hat(v)(S_t, bold(w))) gradient ln pi(A_t|S_t, bold(theta)_t)
    $

  ]

]

// *****************************************************************************

#slide(title: [_One-step actor-critic_])[

  #figure(image("images/one_step_ac.png"))

]

// *****************************************************************************

// #slide(title: [_One-step actor-critic_])[

//   Igualmente aplicable para la función $q(s,a,bold(w))$:

//   #figure(image("images/qac.png"))

// ]

// *****************************************************************************

#slide(title: [Arquitectura _actor-critic_])[

  #figure(image("images/ac_arch.png", width: 53%))

]

// *****************************************************************************

#slide(title: [_One-step actor-critic_])[

  Como hemos visto, las reglas de actualización para actor ($bold(theta)$) y crítico ($bold(w)$) son:

  #framed(title: "Actualización del actor")[
    $bold(theta) <- bold(theta) + alpha_bold(theta)[R_t + gamma hat(v)_pi (S_(t+1), bold(w)) - hat(v) (S_t, bold(w))] gradient ln (pi(A_t | S_t, bold(theta)))$
  ]

  #framed(title: "Actualización del crítico")[
    $bold(w) <- bold(w) + alpha_bold(w)[R_t + gamma hat(v)_pi (S_(t+1), bold(w)) - hat(v) (S_t, bold(w))] gradient hat(v)_pi (S_t, bold(w))$
  ]

  - A diferencia de REINFORCE con _baseline_, se utiliza el _TD target_ en lugar del retorno.

  #emoji.warning #stress[IMPORTANTE]: *Estas actualizaciones son similares si empleamos la función* $q(s,a)$.

]

// *****************************************************************************

#slide(title: [Ventajas de _actor-critic_])[

  - Los métodos _actor-critic_ permiten *actualizaciones más frecuentes* de los parámetros de la política, ya que no es necesario esperar al final del episodio para obtener el retorno.

    - De hecho, podemos ajustar al nivel de _bootstrapping_ a emplear (número de _steps_ hacia delante).

  - Mientras que se aumenta el *sesgo* (_bias_), la *varianza* de la actualización de los parámetros se reduce, ya que se emplea una estimación del retorno en lugar del retorno real.

  - Esto da lugar a una velocidad *convergencia* mayor, y favorece la aplicación en *problemas continuados*.
]

// *****************************************************************************

#focus-slide([Función de ventaja])

// *****************************************************************************

#slide(title: [Función de ventaja])[

  La #stress[función de ventaja] $A(s,a)$ nos permite cuantificar *cómo de buena es una acción* $a$ en un estado $s$ en comparación con el valor de dicho estado. Esto es:

  #grayed[$ A(s,a) = Q(s,a) - V(s) $]

  La función de ventaja *implica conocer* $Q(s,a)$ y $V(s)$, o contar al menos con una aproximación de estas.

]


// *****************************************************************************

#slide(title: [Función de ventaja])[

  Dado que $ Q(s,a) = r + gamma V(s')$, podemos reescribir $A(s,a)$ tal que:

  #grayed[ $ A(s,a) = underbrace(r + gamma V(s') - V(s), "TD-error") $]

  Es decir...

  #align(center)[#framed[El _TD-error_ es un buen estimador de la función de ventaja.]]


]

// *****************************************************************************

#slide(title: [Función de ventaja])[

  #grayed[ $ A(s,a) &= Q(s,a) - V(s) &= r + gamma V(s') - V(s) $]

  - Si elegir una acción $a$ en un estado $s$ resulta en un retorno $Q(s,a)$ mayor que el valor de dicho estado $V(s)$, la función de ventaja será positiva, $A(s,a) > 0$.

  Esto hace que su aplicación en los métodos vistos sea interesante, ya que permite *reforzar* acciones que resultan en retornos superiores a la media, y *reducir* la probabilidad de acciones que resultan en retornos inferiores.

  - Es por esto que los métodos _actor-critic_ también suelen denominarse en la literatura como #stress[_advantage actor-critic_].
]


// *****************************************************************************

#slide(title: [Función de ventaja])[

  De forma general, el gradiente del rendimiento $gradient J(bold(theta))$ se puede expresar como:

  #grayed[
    $
      gradient J(bold(theta)) = EE_pi_bold(theta) [gradient_bold(theta) ln pi_bold(theta) (s,a) A(s, a)]
    $
  ]

  Así, la #stress[función de ventaja] se define de diferente forma dependiendo del método empleado:

  #cols(gutter: .1cm)[
    #framed(title: [#text(size: 22pt)[REINFORCE con _baseline_]])[
      #set text(size: 25pt)
      $A(s,a) &tilde.eq G_t - hat(v)(s)$

    ]
    #h(1cm) _Empleando retornos empíricos._
  ][
    #v(-1.2cm)
    #framed(title: [_Actor-critic_])[
      #set text(size: 23pt)
      $A(s,a) &tilde.eq hat(q)_pi (s,a) - hat(v)_pi (s)\ &tilde.eq r + gamma hat(v)_pi (s') - hat(v)_pi (s)$]
    #h(1cm) _Empleando retornos estimados._
  ]

]

// *****************************************************************************

#focus-slide("Una posible analogía de los métodos vistos...")

// *****************************************************************************

#slide[

  #cols(columns: (2fr, 1fr), gutter: 2cm)[
    #framed(title: [REINFORCE])[

      - Juego un partido de tenis contra un amigo.

      - *Al final del partido*, analizo cómo he jugado y pienso en qué he de mejorar.

    ]
  ][
    #image("images/tenis.jpg", width: 100%)
  ]

  Mejoro lentamente, y mi forma de jugar varía abruptamente hasta dar con la mejor forma de ganar a mi rival.

]

// *****************************************************************************

#slide[

  #cols(columns: (2fr, 1.3fr))[
    #framed(title: [REINFORCE con _baseline_])[

      - Juego un partido de tenis contra un amigo.

      - *Al final del partido*, analizo cómo he jugado y pienso en qué he de mejorar, teniendo como referencia los consejos de mi *entrenador/a*.

    ]

    Mi entrenador/a me ofrece buenos consejos sobre cómo poder superar a mi rival.
  ][
    #image("images/tenis.jpg", width: 85%)
    #image("images/tenis-2.png", width: 90%)
  ]

]

// *****************************************************************************

#slide[

  #cols(columns: (2fr, 1.3fr), gutter: 1cm)[
    #framed(title: [_Actor-critic_])[
      - Juego un partido de tenis contra un amigo.
      - *Tras cada punto*, analizo cómo he jugado y pienso en qué he de mejorar, teniendo como referencia *los consejos de mi entrenador/a*.
    ]

  ][
    #image("images/tenis-3.jpg", width: 110%)
  ]
  Mi entrenador/a me ofrece consejos sobre cómo poder superar a mi rival con mucha más frecuencia, en base a cómo estamos jugando actualmente.

]

// *****************************************************************************

#title-slide([Espacios de acciones continuos])

// *****************************************************************************

#slide(title: [Espacios de acciones continuos])[

  Hasta ahora hemos visto cómo aplicar los métodos basados en _gradient de la política_ empleando #stress[espacios de acciones discretos].

  #cols(columns: (2fr, 1fr))[
    - Es decir, el conjunto de acciones es finito y cada acción tiene una probabilidad asociada.

    #framed[¿Pero qué ocurre si abordamos un problema con #stress[espacio de acciones continuo] / infinito?]
  ][
    #image("images/action_probs.png", width: 100%)
  ]

  Este tipo de espacios de acciones son comunes en problemas de robótica, control de vehículos, etc.

]

// *****************************************************************************

#slide(title: [Espacios de acciones continuos])[

  #cols[
    #figure(image("images/pendulum.png", width: 70%))
  ][
    #figure(image("images/mujoco.jpeg", width: 70%))
  ]

]

// *****************************************************************************

#slide(title: [Espacios de acciones continuos])[

  La forma de abordar estos problemas es sustituyendo la distribución categórica de acciones por una #stress[distribución continua] (ej. gaussiana).

  #figure(image("images/distrib.png"))

  - La política se modela como una distribución de densidad de probabilidad. Por ejemplo, una *distribución normal*:

  $ pi(a|s, bold(theta)) = cal(N)(a; mu(s,bold(theta)), sigma(s, bold(theta))) $

]

// *****************************************************************************

#slide(title: [Espacios de acciones continuos])[

  #grayed[$ pi(a|s, bold(theta)) = cal(N)(a; mu(s,bold(theta)), sigma(s, bold(theta))) $]

  - $a$ es una acción en el espacio continuo
  - $s$ es el estado observado
  - $mu(s,bold(theta))$ es la media de la distribución
  - $sigma(s, bold(theta))$ es la desviación estándar de la distribución

  #v(.3cm)

  #framed[Los espacios de acciones continuas son una generalización de los espacios de acciones discretos. Permiten abordar problemas con mayor precisión a costa de una mayor complejidad.]

]

// *****************************************************************************

#slide(title: [Espacios de acciones continuos])[

  Así, el agente asigna diferentes distribuciones de acciones para diferentes estados.

  #grayed[$
      pi(a|s, bold(theta)) = 1 / (sigma(s,bold(theta))sqrt(2 pi)) exp(-((a - mu(s,bold(theta)))^2)/(2 sigma(s, bold(theta))^2))
    $]

  donde $mu:cal(S) times RR^d' --> RR $ y $sigma: cal(S) times RR^d' --> RR^+$ son funciones paramétricas que definen la distribución de acciones para cada estado.

]


// *****************************************************************************

#slide(title: [Estimación de $mu$ y $sigma$])[

  El proceso seguido para muestrear una acción en un espacio de acciones continuo es el siguiente:

  1. Partimos de un estado arbitrario $s$
  2. Calculamos $mu$ y $sigma$ para dicho estado (por ejemplo, pueden venir dados por una red neuronal)
  3. Muestreamos la acción de la distribución definida por $mu(s, bold(theta))$ y $sigma(s, bold(theta))$.

  #figure(image("images/nn.png"))

]


// *****************************************************************************

#slide(title: [Exploración])[

  #set text(size: 18pt)

  El #stress[valor inicial de $sigma$] es importante, ya que determinará la exploración de la política.
  - Favorece la exploración de forma natural.

  #figure(image("images/sigma.png"))

  #framed[A medida que el agente aprende, la desviación estándar se reduce, lo que implica una menor exploración y una mayor tendencia al comportamiento representado por la acción central de la distribución.]

]

// *****************************************************************************

#title-slide("Trabajo propuesto")

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  #set text(size: 18pt)
  - #stress[Implementar los algoritmos estudiados] y utilizarlos en un entorno de Gymnasium.
    - REINFORCE, REINFORCE con _baseline_ y _1-step actor-critic_.
    - Compara su rendimiento.
    - #link("https://github.com/manjavacas/rl-temario/tree/main/ejemplos/policy_approx/")
  - Implementar un agente en un entorno de Gymnasium con un #stress[espacio de acciones continuo].
  - ¿Qué algoritmos basados en gradiente de la política son más empleados en la actualidad?
    - ¿Y _actor-critic_?
  - Investiga sobre el algoritmo #stress[A2C] y trata de implementarlo.

  #text(size: 24pt)[*Bibliografía y recursos*]

  #set text(size: 13pt)
  - *Capítulo 13* de Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction.
  - #link("https://github.com/MathFoundationRL/Book-Mathematical-Foundation-of-Reinforcement-Learning")
  - #link("https://www.youtube.com/watch?v=e20EY4tFC_Q")
  - #link("https://www.youtube.com/watch?v=AiFM6LZ7Vuo")
  - #link("https://www.youtube.com/watch?v=ZODHxkjkuv4")
  - #link("https://lilianweng.github.io/posts/2018-04-08-policy-gradient/")
  - #link("https://tatika.pythonanywhere.com/post_group/12")
  - #link("https://www.decisionsanddragons.com/")
]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Aproximación de políticas",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)
