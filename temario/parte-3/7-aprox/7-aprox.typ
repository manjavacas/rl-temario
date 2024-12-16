#import "@preview/typslides:1.2.3": *

#show: typslides.with(
  ratio: "16-9",
  theme: "purply",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)

#let colmath(x, color: red) = text(fill: color)[$#x$]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Aproximación de funciones",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents()

// *****************************************************************************


#slide(title: "Recapitulando...")[

  Hemos visto cómo los métodos #stress[tabulares] presentaban una serie de limitaciones:

  #set text(size: 18pt)

  1. *Escalabilidad*. Si el espacio de estados o acciones es demasiado grande, las tablas de valores de $v(s)$ o $q(s,a)$ se vuelven inmanejables.

  2. *Problemas continuos*. Los métodos tabulares no pueden manejar espacios de estados/acciones continuos, o bien requieren _discretizar_ estos espacios.

  3. *Generalización*. Los métodos tabulares tratan cada estado o par acción--estado de forma independiente. Esto les impide generalizar el conocimiento aprendido en un estado a otros estados similares.

    - Si tenemos dos estados cercanos con dinámicas o recompensas similares, los métodos tabulares no pueden sacar provecho de esta relación.

    - Esto _ralentiza_ el aprendizaje, porque implica visitar todos los estados o pares acción--estado para actuar correctamente.

]

// *****************************************************************************

#slide(title: "Métodos aproximados")[

  #framed[La idea principal tras los métodos _aproximados_ es sustituir las #stress[tablas] por #stress[funciones].]

  #v(1cm)

  - Estas funciones de valor aproximadas toman como entrada un estado o par acción--estado, y nos devuelven su *valor aproximado* ($v$, $q$).

  - El *aprendizaje* de las funciones será otro aspecto importante a abordar, ya que se trata de *funciones parametrizadas*.

]

// *****************************************************************************

#slide[
  #figure(image("images/tabular-approx.png"))
]

// *****************************************************************************

#title-slide([Predicción _on-policy_ aproximada])

// *****************************************************************************

#slide(title: [Predicción _on-policy_ aproximada])[

  #framed[*Idea principal*: buscamos obtener una #stress[función estado--valor estimada],\ $hat(v) tilde.eq v_pi$, a partir de experiencia generada siguiendo una política $pi$.]

  - *Aprendizaje _on-policy_*. Utilizamos datos obtenidos mediante la interacción con el entorno para _aprender_ $hat(v)$ de forma _on-policy_.

  - La novedad es que la función de valor ya no se representa como una tabla, sino como una #stress[función parametrizada]. Es decir, tenemos un vector de pesos $bold(w) in RR^d$ tal que:

  #grayed[$hat(v) (s, bold(w)) approx v_pi (s)$]

]

// *****************************************************************************

#slide(title: [Valor aproximado])[

  #grayed[$hat(v) (s, bold(w)) approx v_pi (s)$]

  #v(1cm)

  $hat(v) (s, bold(w))$ es el #stress[valor aproximado] del estado $s$ dado el vector de pesos $bold(w)$.

  - Ej. _$hat(v)$ es la función representada por una red neuronal, siendo $bold(w)$ el vector con los pesos de la red._

  - Ej. _$hat(v)$ es la función representada por un árbol de decisión, siendo $bold(w)$ el vector todos los nodos divisorios y valores en las hojas del árbol._

]

// *****************************************************************************

#slide(title: [Valor aproximado])[

  Normalmente, el número de pesos en $bold(w) in RR^d$ es *mucho menor que el número de estados* $|cal(S)|$, $(d << |cal(S)|)$ por lo que modificar un peso da lugar a una alteración del valor estimado de múltiples estados.

  - De la misma forma, cuando el valor un estado cambia, esta actualización repercute en el valor de otros estados.

  - Esta #stress[generalización] permite un aprendizaje más _eficiente_, pero también potencialmente más complejo de realizar e interpretar.

  La extensión de RL a la aproximación de funciones facilita su aplicación en problemas *parcialmente observables*.

]

// *****************************************************************************

#slide(title: [Aproximación de la función de valor])[

  Representaremos la #stress[actualización del valor de un estado] de la siguiente forma:

  #grayed[$ s |-> u $]

  donde $s$ es el estado cuyo valor se actualiza, y $u$ es el #stress[valor objetivo] (_update target_) hacia el que se dirige el valor estimado de $s$ (_backed-up value_).

  - Cada actualización es un ejemplo del comportamiento esperado para la función de valor (dado un estado $s$, obtenemos una salida $u$, que es su valor objetivo).

]

// *****************************************************************************

#slide(title: [Ejemplos])[

  - Actualización en *Monte Carlo*:

  $ S_t |-> G_t $

  - Actualización en *TD(0)*:

  $ S_t |-> R_(t+1) + gamma hat(v) (S_(t+1), bold(w)_t) $

  - Actualización en *_n-step_ TD*:

  $ S_t |-> G_(t:t+n) $

  - Evaluación de la política en *programación dinámica*:

  $ s |-> EE_pi [R_(t+1) + gamma hat(v)(S_(t+1), bold(w)) | S_t = s] $

]

// *****************************************************************************

#slide(title: [Actualización de valores])[

  La actualización $s |-> u$ denota que el valor estimado de $s$ debería *acercarse* o *ser similar* al valor objetivo $u$.

  - Esto refleja el #stress[comportamiento entrada--salida] deseado para una función de valor.

  Hasta ahora, las actualizaciones eran triviales:

  - El valor de $s$ en la tabla se modifica parcialmente en dirección a $u$, y el resto de estados quedan intactos.

  Pero ahora permitimos que *métodos arbitrariamente complejos* lleven a cabo esta actualización.

  - Además, actualizar $s$ supone una #stress[generalización] que da lugar a la modificación de los valores estimados de otros estados.

]


// *****************************************************************************

#slide(title: [Aproximación de la función de valor])[

  #columns(2)[

    #v(2.5cm)

    El aprendizaje de la función de valor es similar al #stress[aprendizaje supervisado]:

    - Ajustamos un *modelo* mediante ejemplos de entrada--salida para *aproximar la función de valor*.

    #colbreak()

    #figure(image("images/supervised.png", width: 80%))

  ]
]

#slide(title: [Aproximación de la función de valor])[

  #figure(image("images/approximation.png"))

]

// *****************************************************************************

#slide(title: [Objetivo de predicción])[

  En los *métodos tabulares* no necesitábamos una #stress[medida de calidad] de las predicciones.

  - Cada estado podía llegar a su valor verdadero $v_pi (s)$ de forma independiente, sin afectar al valor de otros estados.

  Sin embargo, empleando *aproximación de funciones*, la actualización del valor de un estado repercute sobre el resto.

  - Dada esta interdependencia, no es posible obtener los *valores exactos* de todos los estados.

]

#slide(title: [Error de predicción])[


  El #stress[error] de estimación mide la diferencia entre el valor real $v_pi (s)$ y el aproximado $hat(v) (s, bold(w))$.

  - Se denomina #stress[error de valor cuadrático medio] (_mean squared value error_, MSVE o #stress[#overline("VE")]) y se define tal que:

  #grayed[$overline("VE")(bold(w)) = sum_(s in cal(S)) [v_pi (s) - hat(v) (s, bold(w))]^2$]

  - Esta es nuestra #stress[función objetivo], es decir, aquella que trataremos de optimizar/minimizar.
]

// *****************************************************************************

#slide(title: [Error de predicción ponderado])[

  Como tenemos más estados que pesos, $|cal(S)| >= |bold(w)|$, hacer estimaciones más precisas de unos estados supondrá un deterioro en las estimaciones de otros.

  Podemos decir *qué estados son más relevantes*, de tal forma que el #stress[error] en la estimación de su valor se tenga más en cuenta:

  $ underbrace(mu (s) >= 0, "importancia\n del error de\n estimación para\n el estado s"), sum_s mu(s) = 1 $

  De esta forma, tenemos:

  #grayed[$overline("VE")(bold(w)) = sum_(s in cal(S)) mu(s) [v_pi (s) - hat(v) (s, bold(w))]^2$]

]


// *****************************************************************************

#slide(title: [Error de predicción ponderado])[

  #grayed[$overline("VE")(bold(w)) = sum_(s in cal(S)) mu(s) [v_pi (s) - hat(v) (s, bold(w))]^2$]

  #v(1cm)

  - La raíz cuadrada de esta medida nos dice *cuánto difieren* las estimaciones de los valores reales
    - Ponderando por la importancia asignada al error de cada estado, según $mu(s)$.

]

// *****************************************************************************

#slide(title: [Frecuencia de visita a un estado])[

  - $mu(s)$ puede venir dado por la cantidad de tiempo invertido en $s$.

  Por ejemplo, definamos de la siguiente forma la #stress[frecuencia de visita] a un estado $s$:

  #grayed[$
      eta(s) = h(s) + sum_(s prime) eta(overline(s)) sum_a pi(a | s prime) p(s | s prime, a), #h(1cm) forall s, s prime in cal(S)
    $]

  #set text(size: 19pt)

  donde:

  - $eta(s)$ es el número de _timesteps_ que, de media, el agente pasa en el estado $s$ durante un episodio, ya sea porque comienza en $s$, o porque transiciona desde otro estado $s'$.

  - $h(s)$ es la probabilidad de que el episodio comience en el estado $s$.

]

// *****************************************************************************

#slide(title: [Distribución _on-policy_])[


  Denominamos #stress[distribución _on-policy_], $mu(s)$, a la *fracción de tiempo* invertido en un estado $s$:

  #grayed[$ mu(s) = eta(s) / (sum_s' eta(s')), #h(1cm) forall s in cal(S) $]

  Este valor indica cuánto se ha visitado $s$ con respecto al resto de estados $s' in cal(S)$ a lo largo de un episodio.

  #align(right)[#text(size: 17pt)[$mu(s)$ es un un valor normalizado, tal que $sum_(s in cal(S)) mu(s) = 1 $]]

]

// *****************************************************************************

#slide(title: [Objetivo de predicción])[


  Empleamos #overline[VE] para ajustar progresivamente la *función de valor aproximada* $hat(v)(s, bold(w))$.

  Un objetivo ideal en términos de #overline[VE] podría ser encontrar un #stress[óptimo global] $bold(w)^*$ tal que:

  #grayed[
    $ overline("VE") (bold(w)^*) <= overline("VE") (bold(w)), forall bold(w) $
  ]

  - Encontrar $bold(w)^*$ puede ser viable en modelos sencillos, pero *no* en modelos complejos como redes neuronales o árboles de decisión.

]

// *****************************************************************************

#slide(title: [Objetivo de predicción])[


  La aproximación de funciones mediante modelos complejos puede converger en #stress[óptimos locales], tales que:

  #grayed[
    $ overline("VE") (bold(w)^*) <= overline("VE") (bold(w)), forall bold(w) "próximo a" bold(w)^* $
  ]

  - Pueden ser soluciones subóptimas, aunque normalmente son *suficientes* para obtener una buena política.

  - Incluso hay problemas de RL donde las soluciones óptimas son inalcanzables.

]

// *****************************************************************************

#title-slide([Gradiente estocástico y\ métodos semi-gradiente])

// *****************************************************************************

#slide(title: "Función de valor diferenciable")[
  #columns(2)[

    #v(.8cm)

    Consideramos que $hat(v)(s, bold(w))$ es una #stress[función diferenciable] con respecto al vector de pesos $bold(w), forall s in cal(S)$.

    #v(.4cm)

    Nuestro objetivo será obtener $bold(w) tilde.eq bold(w)^*$, tal que $hat(v)(s, bold(w)) tilde.eq v(s)$.

    #colbreak()

    #grayed[$hat(v) (s, bold(w))$]

    #grayed[$bold(w) = vec(w_1, w_2, dots, w_n)$]

  ]

  - Como inicialmente no contamos con un vector de pesos $bold(w)$ capaz de proporcionar el valor correcto para todos los estados, trataremos de ajustarlo de forma #stress[iterativa].

]

// *****************************************************************************

#slide(title: "Función de valor diferenciable")[

  - El vector de pesos $bold(w)$ se actualizará en cada _timestep_, por lo que emplearemos $w_t$ para denotar los pesos del modelo en el instante $t = 0, 1, 2, 3, dots$

  - Asumimos que los estados son seleccionados de acuerdo a la misma distribución, $mu$, y que buscamos minimizar el error $overline("VE")$.

  - Emplearemos #stress[gradiente estocástico descendente] (_stochastic gradient descent_, #stress[SGD]) para llevar a cabo la optimización de $bold(w)$.

]

// *****************************************************************************

#focus-slide("Gradiente estocástico descendente")

// *****************************************************************************

#slide(title: "Gradiente estocástico descendente")[

  #columns(2)[

    #v(1cm)

    #framed[SGD es un algoritmo de optimización empleado para minimizar una función de #stress[error] (pérdida, _loss_) ajustando los parámetros $bold(w)$ de un modelo.]

    #colbreak()

    #figure(image("images/sgd.png"))

  ]

]

// *****************************************************************************

#slide(title: "Gradiente estocástico descendente")[

  #columns(2, gutter: 1cm)[

    #v(.2cm)

    - La #stress[función de error] $E(bold(w))$ indica cómo de buena es la predicción del modelo con respecto al valor real.

    - El #stress[gradiente de la función de error] con respecto a los pesos es un vector que apunta en la *dirección del mayor incremento del error*:

    #grayed[$gradient E(bold(w)) = [(diff E) / (diff w_1), (diff E) / (diff w_2), dots, (diff E) / (diff w_d)]^T$]

    #colbreak()

    #v(.5cm)

    #figure(image("images/sgd.png"))

  ]

]

// *****************************************************************************

#slide(title: "Gradiente estocástico descendente")[

  #columns(2)[

    Para minimizar el error, nos moveremos en la #stress[dirección opuesta al gradiente].

    - Esta es la *dirección en la que el error disminuye más rápidamente*.

    La actualización de los pesos se lleva a cabo de la siguiente forma:

    #grayed[$ bold(w) <- bold(w) - eta gradient E(bold(w)) $]

    #set text(size: 19pt)

    donde $eta$ es la _tasa de aprendizaje_ que controla el _tamaño_ de la actualización.

    #colbreak()

    #v(1.5cm)

    #figure(image("images/sgd.png"))

  ]

]

// *****************************************************************************

#focus-slide([Aplicado a nuestro problema...])


// *****************************************************************************

#slide(title: [Actualización iterativa de $bold(w)$ mediante SGD])[

  #text(size: 19pt)[El proceso general empleado para aproximar $bold(w)$ es el siguiente:

    1. En cada _timestep_, observamos un ejemplo $S_t |-> v_pi (S_t)$, dado un estado aleatorio $S_t$ y su valor verdadero $v_pi (S_t)$.

    2. Comparamos $v_pi (S_t)$ con el valor predicho por $hat(v) (S_t, bold(w))$, obteniendo así el error de predicción $overline("VE")$.

    3. Ajustamos $bold(w)$ en una pequeña fracción, $alpha$. La dirección de dicho ajuste vendrá guiada por la minimización de $overline("VE")$ que indique el gradiente:]

  #grayed[
    #show math.equation: set text(size: 26pt)
    $bold(w)_(t+1) &= bold(w)_t - 1 / 2 alpha gradient [v_pi (S_t) - hat(v) (S_t, bold(w)_t)]^2 \
      &= bold(w)_t - alpha[v_pi (S_t) - hat(v) (S_t, bold(w)_t)] gradient hat(v) (S_t, bold(w)_t)$
  ]

  #set text(size: 14pt)

  #align(right)[\* Consideramos $overline("VE") (bold(w))= 1/2 [v_pi (S_t) - hat(v) (S_t, bold(w))]^2$. El valor $1/2$ es opcional, y se emplea para simplificar derivadas.]

]

// *****************************************************************************

#slide(title: [Actualización iterativa de $bold(w)$ mediante SGD])[

  #show math.equation: set text(size: 35pt)

  #let x = text(fill: red)[Tamaño del error]
  #let y = text(fill: blue)[Dirección de #linebreak() la actualizacion]

  #grayed[
    $
      bold(w) <- bold(w) - alpha[underbrace(v_pi (S_t) - hat(v) (S_t, bold(w)_t), #x) ] underbrace(gradient hat(v) (S_t, bold(w)_t), #y)
    $
  ]

]

// *****************************************************************************

#slide(title: [Actualización iterativa de $bold(w)$ mediante SGD])[

  - En nuestro caso, el vector de derivadas parciales es:

  $
    gradient overline("VE")(bold(w)) = vec((diff overline("VE")) / (diff w_1), (diff overline("VE")) / (diff w_2), dots, (diff overline("VE")) / (diff w_d))
  $

  - SGD es *estocástico* porque el estado observado en cada _timestep_ es aleatorio.

  - A lo largo de múltiples observaciones, se van sucediendo observaciones y pequeños pasos hacia la reducción del error $overline("VE")$, mejorando la aproximación de la función de valor estimada $hat(v)$.

]

// *****************************************************************************

#slide(title: "Convergencia")[

  La reducción del error (actualización de $bold(w)$) se realiza en pasos pequeños porque *no* esperamos encontrar una solución perfecta para todos los estados, sino más bien una aproximación que suponga un #stress[error balanceado] para todos los estados.

  - Si corrigiésemos completamente el error para el estado actual en cada _timestep_, nunca obtendríamos dicho balance.

  - Perderíamos capacidad de *generalización*.

  No obstante, para asegurar la convergencia de SGD, debemos permitir que $alpha$ (_step size_) #stress[se reduzca con el tiempo].

  - Si esto ocurre, SGD *siempre convergerá en un óptimo local*.

]

// *****************************************************************************

#slide(title: "Balance de error")[

  #v(-1.1cm)

  #figure(image("images/error.png"))

]

// *****************************************************************************

#slide[

  #set text(size: 27pt)

  #framed[#emoji.face.think ¿Pero y si no contamos con $v_pi$ para calcular el *error*?]

  #v(1cm)

  - ¿Podríamos actualizar correctamente $bold(w)$ si en vez de utilizar $v_pi$ para calcular $overline("VE")$ utilizamos un *valor aproximado*?

]

// *****************************************************************************

#slide(title: "Valor objetivo aproximado")[

  #set text(size: 25pt)

  Es decir...

  #v(.3cm)

  #framed[¿Qué ocurriría si el #stress[valor objetivo] (_target output_) $U_t in RR$ tal que $S_t |-> U_t$, no es el valor exacto de $v_pi (S_t)$?]

  #v(.4cm)

  - Supongamos que es un *valor aleatorio aproximado*, similar a $v_pi (S_t)$ pero con cierto ruido, o un valor estimado obtenido mediante _bootstrapping_ a partir de $hat(v)$.

]

// *****************************************************************************

#slide(title: "Valor objetivo aproximado")[

  En ese caso, la actualización de $bold(w)$ no será exacta, porque no conocemos $v_pi (S_t)$.

  Igualmente, podemos aproximarlo sustituyendo $v_pi (S_t)$ por $U_t$, dando lugar a la siguiente actualización de $bold(w)$:

  #grayed[$bold(w)_(t+1) = bold(w)_t - alpha [U_t - hat(v)(S_t, bold(w)_t) gradient hat(v)(S_t, bold(w)_t)]$]

  siendo $U_t$ una #stress[estimación no sesgada] de $v_pi (S_t)$.

  #align(center)[
    #framed[Si $EE[U_t | S_t = s] = v_pi (S_t), forall t = 0, 1, 2, dots$\ se garantiza que $bold(w)_t$ *convergerá en un óptimo local* empleando SGD.]
  ]
]

// *****************************************************************************

#focus-slide([Métodos de\ estimación de $hat(v)$])

// *****************************************************************************

#slide(title: [Estimación Monte Carlo de $hat(v)$])[

  *Monte Carlo* aproxima $hat(v)$ con garantías porque su _target_ $U_t = G_t$ es una estimacioń #stress[no sesgada] (_unbiased target_) de $v_pi$. Es decir, estamos sustituyendo:

  #grayed[$ w <- w + alpha [ bold(colmath(v_pi (S_t))) - hat(v)(S_t, bold(w))] gradient hat(v)(S_t, bold(w)) $]

  por:

  #grayed[$ w <- w + alpha [ bold(colmath(G_t)) - hat(v)(S_t, bold(w))] gradient hat(v)(S_t, bold(w)) $]

  teniendo en cuenta que $ #emoji.checkmark.box v_pi (s) = EE_pi [G_t | S_t = s] $

]

// *****************************************************************************

#slide(title: [Estimación Monte Carlo de $hat(v)$])[

  La estimación del gradiente sigue siendo la misma.

  - #stress[Utilizar retornos estimados obtenidos a través de _sampling_ no afecta al objetivo del descenso del gradiente.]

  #grayed[$ w <- w + alpha [ bold(G_t) - hat(v)(S_t, bold(w))] gradient hat(v)(S_t, bold(w)) $]

]

// *****************************************************************************

#slide(title: [Estimación Monte Carlo de $hat(v)$])[

  #framed[*Idea intuitiva*: sustituyo el valor real $v(S_t)$ de cada estado por la recompensa total $G_t$ que espero obtener en base a mi experiencia.

    - Como nos basamos en experiencia obtenida a partir de trayectorias reales, decimos que $U_t = G_t$ es una estimación *no sesgada* de la función de valor.

  ]

]

// *****************************************************************************

#slide(title: [Estimación Monte Carlo de $hat(v)$])[

  La idea general es la siguiente:

  #v(1cm)

  #align(center)[
    #framed[
      #set align(left)

      _Gradient MC_

      1. Generar episodio $S_0, A_0, R_1, S_1, A_1, R_2, dots$ siguiendo $pi$.

      2. Para cada _step_ del episodio, actualizar $bold(w)$ tal que:

        $ bold(w) <- bold(w) + alpha [G_t - hat(v) (S_t, bold(w)) gradient hat(v)(S_t, bold(w))] $

        basándonos en retornos muestreados ($G_t$).

    ]
  ]
]

// *****************************************************************************

#slide(title: [Estimación Monte Carlo de $hat(v)$])[

  #figure(image("images/gradient-mc.png"))

]

#slide()[

  #align(center)[
    #set text(size: 30pt)
    #framed[#emoji.face.think ¿Y podríamos combinar TD #linebreak() con aproximación de funciones?]
  ]

  #v(1cm)

  - En _Gradient MC_, la actualización de los pesos se hacía conforme a $U_t = G_t$, pero realmente el _target_ puede ser cualquier otra estimación del valor.

  Por ejemplo...
]

// *****************************************************************************

#slide(title: [Diferentes _targets_ para medir el error])[

  - *_n-step return_*:

  #grayed[$ U_t = G_(t:t+n) $]

  - *_DP target_*:

  #grayed[$ U_t = sum_(a,s prime, r) pi(a|S_t)p(s prime, r| S_t, a)[r + gamma hat(v) (s prime, bold(w)_t)] $]

  Son estimaciones basadas en otros valores estimados (#stress[_bootstrapping_]).
]

// *****************************************************************************

#slide(title: [Métodos semi-gradiente])[

  - Empleando métodos basados en _bootstrapping_, se actualiza $bold(w)$ a partir de estimaciones.

  - Hay que tener en cuenta que estos valores están sesgados y *no producen un verdadero descenso del gradiente*.

  #align(center)[
    #framed[Se les denomina #stress[métodos semi-gradiente] (_semi-gradient methods_).]
  ]

  - Por ejemplo, para #stress[_semi-gradient_ TD(0)], el valor objetivo (_bootstrap target_) es:

  #grayed[$ U_t = R_(t+1) + gamma hat(v) (S_(t+1), bold(w)) $]

]

// *****************************************************************************

#slide(title: [_Semi-gradient TD(0)_])[

  #figure(image("images/semi-gradient-td.png"))

]

// *****************************************************************************

#slide(title: [Métodos semi-gradiente])[

  Los métodos semi-gradiente no convergen de forma tan robusta, pero ofrecen ciertas *ventajas* que los hacen preferibles:

  #v(.5cm)

  #emoji.snowboarding #stress[Velocidad de aprendizaje]. Las actualizaciones presentan una menor varianza.

  #emoji.brain #stress[Aprendizaje _online_]. No es necesario esperar a obtener $G_t$.

  #emoji.playback.repeat #stress[Problemas continuados]. Son aplicables a problemas sin un _final_ de episodio.

]

// *****************************************************************************

#focus-slide([Agregación de estados])

// *****************************************************************************

#slide(title: [Agregación de estados])[

  Cabe destacar el concepto de #stress[agregación de estados] (_state aggregation_).

  - Se trata de una técnica que permite generalizar la aproximación de funciones, de tal forma que los estados se agrupan de acuerdo a un mismo valor estimado / vector de pesos $bold(w)$.

  - El valor de cada estado se actualiza junto al valor de cada componente del mismo grupo.

  - Es un caso especial de SGD donde el gradiente $gradient hat(v) (S_t, bold(w))$ es $1$ para los estados en el grupo de $S_t$ y $0$ para el resto.

  #emoji.checkmark.box Simplifica el número de parámetros del modelo.

  #emoji.crossmark Se producen pérdidas de información propias de la discretización del espacio de estados.

]

// *****************************************************************************

#slide(title: [Agregación de estados])[

  #figure(image("images/aggregation.png"))

]

// *****************************************************************************

#title-slide("Métodos lineales")

// *****************************************************************************

#slide(title: "Métodos lineales")[

  ...

]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Aproximación de funciones",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)