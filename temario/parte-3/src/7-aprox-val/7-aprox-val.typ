#import "@preview/typslides:1.2.5": *

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
  subtitle: "Aproximación de funciones de valor",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents(title: "Contenidos")

// *****************************************************************************

#slide(title: "Recapitulando...")[

  Hemos visto cómo los métodos #stress[tabulares] presentaban una serie de limitaciones:

  #set text(size: 18pt)

  1. *Escalabilidad*. Si el espacio de estados o acciones es demasiado grande, las tablas de valores de $v(s)$ o $q(s,a)$ se vuelven inmanejables.

  2. *Problemas continuos*. Los métodos tabulares no pueden manejar espacios de estados/acciones continuos, o bien requieren _discretizar_ estos espacios.

  3. *Generalización*. Los métodos tabulares tratan cada estado o par acción--estado de forma independiente. Esto les impide generalizar el conocimiento aprendido de un estado a otros similares.

    - Si tenemos dos estados cercanos con dinámicas o recompensas similares, los métodos tabulares no pueden sacar provecho de esta relación.

    - Esto _ralentiza_ el aprendizaje, porque implica visitar todos los estados o pares acción--estado para actuar correctamente.

]

// *****************************************************************************

#slide(title: "Métodos aproximados")[

  #framed[La idea principal tras los métodos _aproximados_ es sustituir las #stress[tablas] por #stress[funciones].]

  #v(1cm)

  - Estas #stress[funciones de valor aproximadas] toman como entrada un estado o par acción--estado, y nos devuelven su *valor aproximado* ($v$, $q$).

  - El *aprendizaje* de las funciones será otro aspecto importante a abordar, ya que se trata de *funciones parametrizadas*.

]

// *****************************************************************************

#slide[
  #figure(image("images/tabular-approx.png"))
]

// *****************************************************************************

// #slide(title: "Por ejemplo...")[
//     #figure(image("images/table.png"))
// ]

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

  - Ej. _$hat(v)$ es la función representada por un polinomio de grado $n$, siendo $bold(w)$ el vector de coeficientes._

  - Ej. _$hat(v)$ es la función representada por una red neuronal, siendo $bold(w)$ el vector con los pesos de la red._

]

// *****************************************************************************

#slide(title: [Valor aproximado])[

  #framed[Normalmente, el número de pesos en $bold(w) in RR^d$ es *mucho menor que el número de estados* $|cal(S)|$, $(d << |cal(S)|)$ por lo que modificar un peso da lugar a una alteración del valor estimado de múltiples estados.]

  - De la misma forma, cuando el valor de un estado cambia, esta actualización repercute en el valor de otros estados.

  - Este tipo de #stress[generalización] permite un aprendizaje más _eficiente_, pero también potencialmente más complejo de realizar e interpretar.

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

  El aprendizaje de la función de valor es similar al #stress[aprendizaje supervisado].

  Ajustamos un *modelo* mediante ejemplos de entrada--salida:

  #v(.2cm)

  #columns(2)[

    #framed(title: "Aprendizaje supervisado")[$(bold(X_1), Y_1), (bold(X_2), Y_2), (bold(X_3), Y_3), dots$]

    #colbreak()

    #framed(title: "En nuestro caso...")[$(S_1, v_pi (S_1)), (S_2, v_pi (S_2)), dots$]
  ]

]

// *****************************************************************************

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

// *****************************************************************************

#focus-slide([Discriminación _vs._ generalización])

// *****************************************************************************

#blank-slide[

  #figure(image("images/discrim-gener.png"))

]

// *****************************************************************************

#focus-slide("Error de predicción")

// *****************************************************************************

#slide(title: [Error de predicción])[


  #framed[El #stress[error de estimación] mide la diferencia entre el valor real $v_pi (s)$ y el valor aproximado $hat(v) (s, bold(w))$.]

  - Se denomina #stress[error de valor cuadrático medio] (#stress[#overline("VE")], _mean squared value error_, MSVE) y se define tal que:

  #grayed[$ overline("VE")(bold(w)) = sum_(s in cal(S)) [v_pi (s) - hat(v) (s, bold(w))]^2 $]

  - Esta es nuestra #stress[función objetivo], es decir, aquella que trataremos de optimizar/minimizar.
]

// *****************************************************************************

#slide(title: [Error de predicción ponderado])[

  // Como tenemos más estados que pesos, $|cal(S)| >= |bold(w)|$, hacer estimaciones más precisas de unos estados supondrá un deterioro en las estimaciones de otros.

  Podemos decidir *qué estados son más relevantes*, de tal forma que el #stress[error] en la estimación de su valor se tenga más en cuenta:

  $ underbrace(mu (s) >= 0, "importancia\n del error de\n estimación para\n el estado s"), sum_s mu(s) = 1 $

  De esta forma, tenemos:

  #grayed[$ overline("VE")(bold(w)) = sum_(s in cal(S)) mu(s) [v_pi (s) - hat(v) (s, bold(w))]^2 $]

]


// *****************************************************************************

#slide(title: [Error de predicción ponderado])[

  #grayed[$ overline("VE")(bold(w)) = sum_(s in cal(S)) mu(s) [v_pi (s) - hat(v) (s, bold(w))]^2 $]

  #v(1cm)

  - La raíz cuadrada de esta medida nos dice *cuánto difieren* las estimaciones de los valores reales.

  - Ponderando por la importancia asignada al error de cada estado, según $mu(s)$.

]

// *****************************************************************************

#slide(title: [Frecuencia de visita a un estado])[

  Una buena aproximación es que $mu(s)$ venga dado por la cantidad de tiempo invertido en $s$.

  - #text(size: 19pt)[Por ejemplo, definamos de la siguiente forma la #stress[frecuencia de visita] a un estado $s$:]

  #grayed[$
      eta(s) = h(s) + sum_(s prime) eta(overline(s)) sum_a pi(a | s prime) p(s | s prime, a), #h(1cm) forall s, s prime in cal(S)
    $]

  #set text(size: 19pt)

  donde:

  - $eta(s)$ es el número de _timesteps_ que, de media, el agente pasa en el estado $s$ durante un episodio, ya sea porque comienza en $s$, o porque transiciona desde otro estado $s prime$.

  - $h(s)$ es la probabilidad de que el episodio comience en el estado $s$.

]

// *****************************************************************************

#slide(title: [Distribución _on-policy_])[

  Denominamos #stress[distribución _on-policy_] $mu(s)$ a la *fracción de tiempo* invertido en un estado $s$:

  #grayed[$ mu(s) = eta(s) / (sum_s' eta(s')), #h(1cm) forall s in cal(S) $]

  Este valor indica cuánto se ha visitado $s$ con respecto al resto de estados $s' in cal(S)$ a lo largo de un episodio. Sirve para ponderar el *error*.

  #v(.1cm)

  - $mu(s)$ es un un valor normalizado, tal que $sum_(s in cal(S)) mu(s) = 1 $

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

  - Pueden ser soluciones subóptimas, aunque normalmente son *suficientes* para obtener una *buena política*.

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

  #columns(2, gutter: 2cm)[

    #v(3cm)

    #framed[#stress[SGD] es un algoritmo de optimización empleado para minimizar una función de #stress[error] (pérdida, _loss_) ajustando los parámetros $bold(w)$ de un modelo.]

    #colbreak()

    #v(1cm)

    #figure(image("images/sgd.png", width: 120%))

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

    #grayed[$ bold(w) <- bold(w) - alpha gradient E(bold(w)) $]

    #set text(size: 19pt)

    donde $alpha$ es la _tasa de aprendizaje_ que controla el _tamaño_ de la actualización.

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

    3. Ajustamos $bold(w)$ en una pequeña fracción, $alpha$. La dirección de dicho ajuste vendrá guiada por la minimización de $overline("VE")$ según el gradiente:]

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

  La reducción del error (actualización de $bold(w)$) se realiza en pasos pequeños porque *no* esperamos encontrar una solución perfecta, sino más bien una aproximación que suponga un #stress[error balanceado] para todos los estados.

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

#focus-slide([¿Y si no tenemos $v_pi$?])

// *****************************************************************************

#blank-slide[

  #set text(size: 27pt)

  #framed[#emoji.face.think ¿Qué ocurre si no contamos con $v_pi$ para calcular el *error*?]

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

// #slide(title: "Valor objetivo aproximado")[

//   #align(center)[#framed[_The expectation of each stochastic\ gradient equals the gradient of the objective._]]

//   #v(1cm)

//    SGD permite estimar $bold(w)$ a partir de gradientes aleatorios (_sampling_, aproximación "rudiosa" del gradiente).

// ]

// *****************************************************************************

#slide(title: "Valor objetivo aproximado")[

  #v(.5cm)

  En resumen, estamos sustituyendo $v_pi$ en:

  #text(size: 22pt)[#align(center)[#framed[$S_1 |-> v_pi (S_1), S_2 |-> v_pi (S_2), dots$]]]

  por un *_objetivo_ aproximado* tal que:

  #columns(2)[

    #align(center)[#framed(title: "MC")[$S_1 |-> G_1,\ S_2 |-> G_2,\ dots$]]

    #colbreak()

    #align(center)[#framed(
        title: "TD",
      )[$S_1 |-> R_2 + gamma hat(v)(S_2, bold(w)),\ S_2 |-> R_3 + gamma hat(v)(S_3, bold(w)),\ dots$]]

  ]
]

// *****************************************************************************

#focus-slide([Estimación\ Monte Carlo de $hat(v)$])

// *****************************************************************************

#slide(title: [Estimación Monte Carlo de $hat(v)$])[

  *Monte Carlo* aproxima $hat(v)$ con garantías porque su _target_ $U_t = G_t$ es una estimación #stress[no sesgada] (_unbiased target_) de $v_pi$. Es decir, estamos sustituyendo:

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
    #framed(title: "Gradient MC")[
      #set align(left)

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

// *****************************************************************************

#focus-slide([Estimación de $hat(v)$\ mediante _bootstrapping_])

// *****************************************************************************

#slide()[

  #align(center)[
    #set text(size: 30pt)
    #framed[#emoji.face.think ¿Y podríamos combinar TD #linebreak() con aproximación de funciones?]
  ]

  #v(1cm)

  En _Gradient MC_, la actualización de los pesos se hacía conforme a $U_t = G_t$, pero realmente el _target_ podría ser cualquier otra estimación del valor.

  Por ejemplo...
]

// *****************************************************************************

#slide(title: [Diferentes _targets_ para medir el error])[

  - *_n-step return_*:

  #grayed[$ U_t = G_(t:t+n) $]

  - *_DP target_*:

  #grayed[$ U_t = sum_(a,s prime, r) pi(a|S_t)p(s prime, r| S_t, a)[r + gamma hat(v) (s prime, bold(w)_t)] $]

  ¿Qué ocurre si nuestro objetivo $U_t$ es una estimación basada en otros valores estimados?
  #emoji.arrow.r #stress[_bootstrapping_]
]

// *****************************************************************************

#slide(title: [Métodos semi-gradiente])[

  Empleando métodos basados en _bootstrapping_, se actualiza $bold(w)$ a partir de estimaciones.

  - Por ejemplo, para #stress[_semi-gradient_ TD(0)], el valor objetivo (_bootstrap target_) es:

  #grayed[$ U_t = R_(t+1) + gamma hat(v) (S_(t+1), bold(w)) $]

  - El objetivo depende de $bold(w)$, por lo que *varía constantemente*, cada vez que se actualiza $bold(w)$.

  - Por eso decimos que el objetivo está #stress[sesgado].

]

// *****************************************************************************

#slide(title: [Métodos semi-gradiente])[

  #grayed[$ U_t = R_(t+1) + gamma hat(v) (S_(t+1), bold(w)) $]

  Si el objetivo está #stress[sesgado], *no se produce un verdadero descenso del gradiente*.


  #framed[Debido a esto, a los metodos que estiman $hat(v)$ mediante _bootstrapping_ se les denomina #stress[métodos semi-gradiente] (_semi-gradient methods_).]

  - No podemos garantizar la convergencia en un óptimo local.
  - No obstante, convergen en la mayoría de los casos.
  - El sesgo se reduce a medida que las estimaciones mejoran.

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

  #v(1cm)
  #set text(size: 17pt)
  #framed[#emoji.finger.r En la práctica el aprendizaje rápido es más útil que el rendimiento asintótico, lo que hace que TD sea mejor que MC en la mayoría de problemas.]

]

// *****************************************************************************

#slide(title: [Semi-gradiente _n-step_])[
  #set text(size: 24pt)
  Si ampliamos TD(0) al caso #stress[_n-step_] tendremos el siguiente algoritmo...
]

// *****************************************************************************

#slide(title: [Semi-gradiente _n-step_])[
  #figure(image("images/n-step-semi-gradient.png"))
]

// *****************************************************************************

#focus-slide([Agregación de estados])

// *****************************************************************************

#slide(title: [Agregación de estados])[

  Cabe destacar el concepto de #stress[agregación de estados] (_state aggregation_).

  - Se trata de una técnica que permite generalizar la aproximación de funciones, de tal forma que los estados *se agrupan* de acuerdo a un mismo valor estimado / vector de pesos $bold(w)$.

  - El valor de cada estado se actualiza junto al valor de los estados del mismo grupo.

  - Es un caso especial de SGD donde el gradiente $gradient hat(v) (S_t, bold(w))$ solo considera los estados en el grupo de $S_t$ y se ignora para el resto.

  #emoji.checkmark.box Simplifica el número de parámetros del modelo.

  #emoji.crossmark Necesario establecer un criterio de agrupamiento. Puede perderse información.

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  Consideremos el siguiente ejemplo (_random walk_), con $pi =$ {#emoji.arrow.r : 0.5, #emoji.arrow.l: 0.5}, $gamma = 1$.

  #figure(image("images/example-random-walk.png", width: 95%))

  #set text(size: 21pt)

  Cada *acción* supone saltar a un estado aleatorio entre los 100 estados inmediatamente anteriores/posteriores.

  Por ejemplo, desde el estado 500, la acción #emoji.arrow.r podría llevar al agente a cualquier estado en $[501, 600]$.

  - Podemos agrupar los estados de 100 en 100, dando lugar a 10 grupos.

]

#slide(title: "Ejemplo")[
  #set text(size: 28pt)
  #align(center)[Tras $N$ episodios, estos son los resultados obtenidos...]
]

// *****************************************************************************

#blank-slide[
  #v(1.2cm)
  #figure(image("images/random-walk-values.png", width: 90%))
]

// *****************************************************************************

#focus-slide("Pregunta...")

// *****************************************************************************

#blank-slide()[

  #set align(center)
  #set text(size: 28pt)

  #framed[#emoji.quest ¿En qué se diferencian?]

  #v(1cm)

  *Discretización* del espacio de estados

  *Agregación* de estados

]

// *****************************************************************************

#slide(title: [Discretización _vs._ agregación])[

  #set text(size: 21pt)

  #framed(title: "Discretización")[
    *División* de un espacio continuo en valores discretos. #linebreak()
    #emoji.circle.blue Ej. Temperatura $in RR ->$ {baja, media, alta}.
  ]

  #framed(title: "Agregación")[
    Agrupamiento de las *actualizaciones* de múltiples estados. #linebreak()
    #emoji.circle.red Ej. ubicaciones cercanas en un mapa se consideran el mismo estado y se actualizan igual.
  ]

]

// *****************************************************************************

#slide(title: [Discretización])[

  #figure(image("images/discretization.png", width: 110%))

]

// *****************************************************************************

#slide(title: [Agregación de estados])[

  #figure(image("images/aggregation.png", width: 110%))

]
// *****************************************************************************

#title-slide("Métodos lineales")

// *****************************************************************************

#slide(title: "Métodos lineales")[

  #framed[Un caso relevante en aproximación de funciones es aquel en el cual $hat(v)(dot, bold(w))$ es una #stress[función lineal] de $bold(w)$.]

  #h(.6cm) Esto es, para cada estado $s$ existe un vector de valores $bold(x)$ tal que:

  #grayed[$bold(x)(s) = vec(x_1 (s), x_2 (s), dots, x_d (s))$ ]

  #h(.6cm) Este vector *contiene el mismo número de elementos* que $bold(w)$.

  #h(.6cm) #emoji.arrow.r Como $|bold(x)| = |bold(w)|$, existe #stress[una valor $x_i$ por peso $w_i$].

]

// *****************************************************************************

#slide(title: "Función lineal aproximada")[

  Los métodos lineales aproximan la función estado--valor empleando el producto escalar entre $bold(w)$ y $bold(x)(s)$:

  #grayed[$
      hat(v)(s, bold(w)) &= bold(w)^T bold(x)(s)\
      &= sum^d_(i=1) w_i x_i (s)
    $]

  #framed[Denominamos a $bold(x)(s)$ #stress[vector de características] (_feature vector_) del estado $s$.]

  - Cada componente $x_i (s)$ en $bold(x) (s)$ es el valor de una función $x_i : cal(S) -> RR$.

]

// *****************************************************************************

#slide(title: "Función lineal aproximada")[

  Podemos emplear SGD para aproximar funciones lineales. El gradiente en este caso sería:

  #grayed[$ gradient hat(v) (s, bold(w)) = bold(x) (s) $]

  Y la actualización de pesos se reduce a:

  #grayed[$bold(w)_(t+1) = bold(w)_t + alpha[U_t - hat(v) (S_t, bold(w)_t)] bold(x)(S_t)$]

]

// *****************************************************************************

#slide(title: "Convergencia")[

  En la aproximación de funciones lineales, sólo existe un óptimo, por lo que cualquier método que pueda converger en un *óptimo local* lo hará también en el *global*.

  - #stress[Monte Carlo] converge en el óptimo global de $overline("VE")$ siguiendo una aproximación de función lineal siempre que $alpha$ tienda a $0$ con el tiempo.

  - ¿Y #stress[TD]?
]

// *****************************************************************************

#focus-slide("Aproximación de funciones lineales con TD")

// *****************************************************************************

#slide(title: "Aproximación de funciones lineales con TD")[

  Partimos de la regla de actualización previamente presentada:

  #grayed[$ bold(w) <- bold(w) + alpha delta_t gradient hat(v) (S_t, bold(w)) $]

  donde $delta_t$ es el _TD-error_ definido tal que:

  #let err = text(fill: red)[TD-error]
  #let tar = text(fill: blue)[TD-target]

  #grayed[$underbrace(delta_t = underbrace(R_(t+1) + gamma hat(v) (S_(t+1), bold(w)), #tar) - hat(v) (S_(t+1), bold(w)), #err)$]
]

// *****************************************************************************

#slide(title: "Aproximación de funciones lineales con TD")[

  #grayed[$ bold(w) <- bold(w) + alpha delta_t gradient hat(v) (S_t, bold(w)) $]

  - Los pesos $bold(w)$ se ajustan en la dirección del _TD-error_ $times$ el gradiente de la función de valor aproximada.

  En el caso lineal, dicho gradiente es simplemente el *vector de características*:

  $ hat(v) (S_t, bold(w)) = bold(w)^T bold(x)(S_t) $

  $ gradient hat(v) (S_t, bold(w)) = bold(x)(S_t) $

]

// *****************************************************************************

#slide(title: "Aproximación de funciones lineales con TD")[

  Por tanto, tenemos la siguiente actualización de pesos:

  #grayed[$
      bold(w)_(t+1) &= bold(w)_t + alpha delta_t gradient hat(v) (S_t, bold(w)_t) \
      &= bold(w)_t + alpha delta_t bold(x) (S_t)
    $]

  - Los pesos se actualizan en la dirección del _TD-error_ $times$ el vector de características. Esta actualización se denomina *_semi-gradiente lineal_*.

  #framed[La decisión sobre qué características emplear es, por tanto, muy importante.]

]

// *****************************************************************************

#slide(title: "Aproximación de funciones lineales con TD")[

  TD lineal converge en el llamado *_TD fixed-point_* (_ver Sutton & Barto p. 206_ #emoji.books).

  - Es decir, *no optimiza de forma precisa* la función objetivo (el mínimo de $overline("VE")$), sino que el objetivo es ese #stress[punto fijo].

  #set text(size: 18pt)
  #framed[¿Cuál es la relación entre la solución encontrada por TD y la solución óptima global?]

  #set text(size: 22pt)
  #columns(2)[
    #grayed[$
        underbrace(overline("VE")(bold(w)_("TD")), "TD fixed-point") <= 1 / (1 - gamma) underbrace("min"_bold(w) overline("VE")(bold(w)), "valor óptimo")
      $]

    #colbreak()

    Dependiendo de la calidad de las *características* (_features_), el _TD fixed-point_ y el óptimo global serán maś o menos cercanos.
  ]

]

// *****************************************************************************

// #slide(title: "Definición de características")[

//     Los métodos lineales ofrecen *garantías de convergencia* y *eficiencia*, aunque estas ventajas dependen de las características (_features_) elegidos para representar los #stress[estados].

//     #framed(title: "Característica")[
//       Aspecto relevante del espacio de estados.
//       - Ej. localización, velocidad, lectura de sensores, etc.
//     ]

// ]

// *****************************************************************************

#slide(title: "Aproximación de funciones lineales")[

  // #stress[En resumen]: aunque TD lineal no converge en el valor mínimo de $overline("VE")$, sí que converge en el mínimo de un objetivo definido basado en las ecuaciones de Bellman.

  #framed[¿Por qué es interesante la aproximación de funciones lineales?]

  #v(1cm)

  1. TD lineal es una *generalización* de TD tabular y TD con agregación de estados.

  2. Son simples de entender y analizar.

  3. Eficaces si contamos con buenas características, que pueden venir dadas por un experto (_domain knowledge_).

]

// *****************************************************************************

#slide(title: "Aproximación de funciones lineales")[

  #stress[Sin embargo], las funciones lineales también presentan ciertan limitaciones...

  - Son incapaces de capturar *relaciones complejas entre variables*.

  - Requieren de una *definición precisa y manual de las características* que definen un estado.

  Esto motiva el uso de métodos #stress[no-lineales] de aproximación de funciones, tales como las #stress[redes neuronales].

  - Permiten capturar relaciones complejas entre variables / _features_.

]

// *****************************************************************************

#title-slide([Aproximación de funciones no lineales mediante redes neuronales])

// *****************************************************************************

#slide(title: "Redes neuronales")[

  #framed[Las #stress[redes neuronales artificiales] (NNs) son modelos matemáticos conexionistas inspirados en el funcionamiento del cerebro humano.]

  Se componen de una serie de #stress[neuronas] interconectadas y organizadas en #stress[capas].

  #figure(image("images/nn.png", width: 30%))

  - Son *aproximadores generales de funciones*, especialmente útiles para ajustar *funciones no lineales*.


]

// *****************************************************************************

#slide(title: "Redes neuronales")[

  #columns(2)[

    #v(1cm)

    - Dentro de cada #stress[neurona] hay una #stress[función de activación].

    - La entrada de cada neurona es la suma ponderada de las salidas anteriores. Dicha ponderación viene dada por los #stress[pesos] de las conexiones.

    - Su arquitectura más común es la de #stress[red _feedforward_].

    - Distinguimos entre capa de *entrada*, capa de *salida* y capas *ocultas*.

    #colbreak()

    #figure(image("images/neuron.png", width: 50%))

    #figure(image("images/ann.png", width: 85%))

  ]
]

// *****************************************************************************

#slide(title: "Neurona")[

  #figure(image("images/neuron_2.png", width: 90%))

]

// *****************************************************************************

#slide(title: "Funciones de activación")[

  #figure(image("images/activation.png", width: 100%))

]

// *****************************************************************************

#slide(title: "Entrenamiento")[

  #framed[La salida de una red neuronal se obtiene como la combinación de

    1. Los *valores* de las características (entrada de la red).
    2. Los *pesos* asignados a las conexiones entre neuronas.
    3. Los ajustes realizados por las *funciones de activación* a lo largo de las capas de la red.

  ]

  - El #stress[entrenamiento] de una red neuronal implica ajustar los pesos de las conexiones entre neuronas para minimizar progresivamente el error (#stress[_loss_]) entre la predicción/salida de la red y el valor real esperado.

    - En RL, el error puede ser $overline("VE")$. Utilizamos el _TD-error_ para aproximar $v(s)$.

]

// *****************************************************************************

#slide(title: [_Backpropagation_])[

  Generalmente, el entrenamiento de NNs se realiza mediante #stress[SGD], integrado en el algoritmo de #stress[_backpropagation_].

  #framed(title: [Algoritmo de _backpropagation_])[
    1. Pasada hacia delante (_forward pass_) para obtener la salida de la red.

    2. Calcular el error (_loss_).

    3. Pasada hacia atrás (_backward pass_) para calcular los gradientes de la función de pérdida con respecto a los pesos.

    4. Actualización de los pesos (ej. mediante SGD).
  ]
]

// *****************************************************************************

#slide(title: "Redes neuronales")[

  #set text(size: 19pt)

  #columns(2)[
    #framed[#emoji.checkmark.box Existen diferentes formas de *mejorar* el entrenamiento de una red neuronal...]

    - Ajuste de hiperparámetros (ej. _step-size_, número de capas, número de neuronas por capa, funciones de activación, ...).
    - Inicialización de pesos.
    - _Momentum_.
    - _Dropout_.
    - Regularización, normalización.
    - _Early stopping_.
    - ...

    #colbreak()


    #framed[#emoji.crossmark También debemos tener en cuenta algunos *problemas* típicos de las redes neuronales...]

    - Coste computacional.
    - Sobreaprendizaje (_overfitting_).
    - Explicabilidad.
    - Calidad de datos.
    - Desvanecimiento del gradiente.
    - ....
  ]

]

// *****************************************************************************

#slide(title: "Otras arquitecturas")[

  #framed[
    #emoji.pencil Aparte de las _feedforward_, existen múltiles tipos de redes neuronales.

    Su uso dependerá del problema que tratemos de abordar.
  ]

  #columns(2, gutter: 0cm)[

    #v(1cm)

    - Redes convolucionales (CNNs).
    - Redes recurrentes (RNNs).
    - GANs.
    - LSTMs.
    - _Transformers_.
    - ...

    #colbreak()

    #figure(image("images/cnn-atari.png", width: 110%))

  ]

]

// *****************************************************************************

#title-slide([Control _on-policy_ aproximado])

// *****************************************************************************

#slide(title: [Control _on-policy_ aproximado])[

  Hemos visto cómo estimar la función estado-valor $v(s)$ haciendo uso de métodos aproximados.

  #h(2cm) *PREDICCIÓN* #h(.2cm) #emoji.arrow.r #stress[_semi-gradient TD(0)_]

  Nuestro *objetivo* ahora será aproximar la función *acción-valor* $q(s,a)$, de la cual derivaremos la política óptima.

  #h(2cm) *CONTROL* #h(.2cm) #emoji.arrow.r #stress[_semi-gradient SARSA_]

  Es decir, buscamos obtener *de forma _on-policy_*:

  #grayed[$ hat(q)(s, a, bold(w)) tilde.eq q_*(s,a) $]

]

// *****************************************************************************

#slide(title: [Control semi-gradiente episódico])[

  Aproximaremos la función acción-valor $hat(q) tilde.eq q_pi$ empleando muestras de entrenamiento de la forma: $S_t, A_t |-> U_t$, donde $U_t$ es nuestro *valor objetivo* (#stress[_update target_]).

  - Es decir, $U_t$ es una aproximación de $q_pi (S_t, A_t)$.

  En este caso, la actualización basada en descenso del gradiente para aproximar $q(s,a)$ es:

  #grayed[$ bold(w)_(t+1) = bold(w)_(t+1) + alpha[U_t - hat(q)(s,a, bold(w_t))] gradient hat(q)(S_t, A_t, bold(w)) $]

]

// *****************************************************************************

#slide(title: [SARSA _1-step_ semi-gradiente episódico])[

  Por ejemplo, la versión semi-gradiente de #stress[SARSA] emplearía la siguiente actualización de pesos:

  #grayed[
    #set text(size: 21pt)
    $
      bold(w)_(t+1) = bold(w)_t + alpha [R_(t+1) + gamma hat(q)(S_(t+1), A_(t+1), bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t)] gradient hat(q)(S_t, A_t, bold(w)_t)
    $
  ]

  Llamamos a esto #stress[SARSA _1-step_ semi-gradiente episódico] (_episodic semi-gradient 1-step SARSA_).

  - Ofrece las mismas garantías de convergencia y _fixed-point_ que TD(0).

  Se resume en:

  1. Predecir el valor de los pares estado-acción disponibles.
  2. Elegir acción (ej. $epsilon$-_greedy_).
  3. Actualizar el valor estimado.

]

// *****************************************************************************

#slide(title: [SARSA _1-step_ semi-gradiente episódico])[

  #figure(image("images/sarsa-update.png", width: 100%))

]

// *****************************************************************************

#slide(title: [SARSA _1-step_ semi-gradiente episódico])[

  #figure(image("images/semi-grad-sarsa.png", width: 90%))

]

// *****************************************************************************

#slide(title: [Función $q$ estimada])[

  Si empleamos una #stress[red neuronal] para representar $hat(q)(s,a, bold(w))$, esta puede definirse de varias formas...

  #columns(2)[

    #v(1cm)

    - Mientras que la primera forma es apropiada cuando el espacio de acciones es *finito*, la segunda es más apropiada en problemas con valores de acción *continuos*.

    - La última capa oculta representa los _features_ $bold(x)$ tales que:

    $ hat(q)(s,a,bold(w)) eq bold(w)^T bold(x)(s,a) $

    #colbreak()
    #figure(image("images/nns.png"))
  ]
]

// *****************************************************************************

#focus-slide("Garantías de exploración")

// *****************************************************************************

#slide(title: [Garantías de exploración])[

  Para garantizar la *exploración*, empleamos $epsilon$-_greedy_.

  - $A_t = "argmax"_a #h(.1cm) hat(q)(S_t, a, bold(w)) $ con probabilidad $1 - epsilon$.
  - $A_t$ aleatoria con probabilidad $epsilon$.

  Recordemos que (_semi-gradient_) SARSA es un método #stress[_on-policy_], de tal manera que siempre habrá cierta probabilidad de actuar de forma sub-óptima a menos que $epsilon$ se reduzca con el tiempo.

  - No se garantiza una exploración sistémica (_vs._ valores iniciales optimistas), sino que se basa en la aleatoriedad.

  #framed[#emoji.face.think ¿Pero por qué no es posible emplear *valores iniciales optimistas* en problemas con *aproximación de funciones no-lineales*?]

]

// *****************************************************************************

#slide(title: [Garantías de exploración])[

  - En problemas con funciones *lineales* tenemos que $hat(q)(s,a,bold(w)) = bold(w)^T bold(x)(s,a)$, por lo que una forma de asegurar valores iniciales optimistas es asignar pesos iniciales lo suficientemente grandes:

  $ bold(w) <- vec(1000, 1000, 1000, ...) $

  - Pero en problemas *no-lineales*, ¿cómo sabemos qué pesos iniciales de una red neuronal son apropiados? #stress[Es por esto por lo que empleamos $epsilon$-_greedy_.]

  $ hat(q)(s,a,bold(w)) = "RN"(s,a,bold(w))\ bold(w) <- ??? $

]

// *****************************************************************************

#focus-slide("Otros métodos")

// *****************************************************************************

#slide(title: [_Expected SARSA_ con función $q$ aproximada])[

  #framed[¿Podemos generalizar para el caso de _Expected SARSA_?]

  #v(.4cm)

  La regla de actualización de pesos para #stress[_Expected SARSA_] empleando una función acción-valor aproximada sería la siguiente:

  #grayed[
    #set text(size: 21pt)
    $
      bold(w) <- bold(w) + alpha[R_(t+1) + gamma sum_a' pi(a'|S_(t+1)) hat(q)(S_(t+1),a',bold(w)) - hat(q)(S_t, A_t, bold(w))] gradient hat(q)(S_t,A_t,bold(w))
    $
  ]

]

// *****************************************************************************

#slide(title: [_Q-learning_ con función $q$ aproximada])[

  #framed[¿Y en el caso de _Q-learning_?]

  #v(.5cm)

  La regla de actualización de pesos para #stress[_Q-learning_] empleando una función acción-valor aproximada sería la siguiente:

  #grayed[
    #set text(size: 21pt)
    $
      bold(w) <- bold(w) + alpha[R_(t+1) + gamma "max"_a' hat(q)(S_(t+1),a',bold(w)) - hat(q)(S_t, A_t, bold(w))] gradient hat(q)(S_t,A_t,bold(w))
    $
  ]

  - Utilizamos el valor máximo en lugar del valor esperado.

  - Recordemos que _Q-learning_ es un caso especial de _Expected SARSA_.

]

// *****************************************************************************

#title-slide("Recompensa media")

// *****************************************************************************

#slide(title: [Objetivo en MDPs])[

  Hasta el momento, hemos visto dos formas de plantear el *objetivo* de un MDP:

  - Retorno #stress[episódico], empleado en problemas finitos:

  $ G_t = sum^(T-t)_(k=0) r_(t + k + 1) $

  - Retorno #stress[_descontado_], empleable en problemas continuados:

  $ G_t = sum^(infinity)_(k=0) gamma^k r_(t + k + 1) $

  El retorno _descontado_ es útil en entornos tabulares, pero *puede ser problemático* en algunos casos.

  Veamos un ejemplo...

]

// *****************************************************************************

#slide(title: [Ejemplo])[

  - Problema continuado. Partimos de $s$ y podemos seguir $pi_"izq"$ o $pi_"der"$.

  - Todas las transiciones tienen como recompensa +0, excepto las que se indican en la figura.

  #figure(image("images/example.png"))

]

// *****************************************************************************

#slide(title: [Ejemplo])[

  #columns(2)[

    - La política $pi_"izq"$ da lugar a:

    $
      v_"izq" (s) &= 1 + gamma dot 0 + gamma^2 dot 0 + gamma^3 dot 0 + gamma^4 dot 0 \
      &+ gamma^5 dot 1 + gamma^6 dot 0 + dots + \
      &+ gamma^10 dot 1 + gamma^11 dot 0 + dots \
      &= 1 + gamma^5 + gamma^10 + gamma^15 + dots \
      &= sum^(infinity)_(k=0) gamma^(5k) = 1 / (1 - gamma^5) "(serie geométrica)"
    $

    #grayed[ $ v_"izq" (s) = 1 / (1 - gamma^5) $]

    #colbreak()

    #v(2cm)

    #figure(image("images/example.png"))
  ]

]

// *****************************************************************************

#slide(title: [Ejemplo])[

  #columns(2)[

    - La política $pi_"der"$ da lugar a:

    $
      v_"der" (s) &= 0 + gamma dot 0 + gamma^2 dot 0 + gamma^3 dot 0 + gamma^4 dot 2 \
      &+ gamma^5 dot 0 + dots + gamma^9 dot 2 + \
      &+ gamma^10 dot 0 + dots + gamma^14 dot 2 + dots \
      &= sum^(infinity)_(k=0) gamma^(4+5k) dot 2 = (2 gamma^4) / (1 - gamma^5)
    $

    #grayed[ $ v_"der" (s) = (2 gamma^4) / (1 - gamma^5) $]

    #colbreak()

    #v(2cm)

    #figure(image("images/example.png"))
  ]

]

// *****************************************************************************

#slide(title: [Ejemplo])[

  #columns(2)[

    #columns(2)[
      #grayed[ $ v_"izq" (s) = 1 / (1 - gamma^5) $]
      #colbreak()
      #grayed[ $ v_"der" (s) = (2 gamma^4) / (1 - gamma^5) $]
    ]

    Probemos diferentes valores de $gamma dots$

    $gamma = 0.5$ #emoji.arrow.r $v_"izq" (s) tilde.eq 1, #h(.5cm) v_"der" (s) tilde.eq 0.1$

    #h(2cm) $pi_"izq"$ es preferible ( #emoji.crossmark)

    $gamma = 0.9$ #emoji.arrow.r $v_"izq" (s) tilde.eq 2.4, #h(.5cm) v_"der" (s) tilde.eq 3.2$

    #h(2cm) $pi_"der"$ es preferible ( #emoji.checkmark.box)

    #colbreak()

    #v(2cm)

    #figure(image("images/example.png"))
  ]

]

// *****************************************************************************

#slide(title: [Ejemplo])[

  #columns(2)[

    - Si queremos encontrar el valor de $gamma$ mínimo que nos lleve a una solución válida:

    $v_"der" (s) > v_"izq" (s)$ cuando $gamma > 2^(-1/4) tilde.eq 0.841 $

    #v(1cm)

    #framed[El problema ante el que nos encontramos es que la magnitud del valor de descuento $gamma$ depende del número de estados del problema.]

    #colbreak()

    #v(2cm)

    #figure(image("images/example.png"))

  ]

]

// *****************************************************************************

#slide(title: [Ejemplo])[

  En este caso, necesitaríamos que $gamma > 2^(-1/99) tilde.eq 0.993 $

  #figure(image("images/example-2.png", width: 50%))

  A medida que aumenta el número de estados, #stress[$gamma$ tiende a 1 asintóticamente].

  - ¡Pero $gamma$ no puede ser $=1$ al tratarse de un problema continuado!

  - Y si es cercano a 1, la suma tiende a infinito.
]

// *****************************************************************************

#slide(title: [Recompensa media])[

  Para evitar este tipo de problemas, se plantea una alternativa: la #stress[recompensa media].

  #grayed[$
      r(pi) &= lim_(h-->infinity) 1 / h sum^h_(t=1) EE[R_t | S_0, A_(0:t-1) tilde pi] \
      &= lim_(t-->infinity) EE[R_t | S_0, A_(0:t-1) tilde pi] \
      &= sum_s mu_pi (s) sum_a pi(a|s) sum_(s',r) p(s', r | s,a)r
    $
  ]

  donde $mu_pi (s)$ es la distribución de visitas a un estado $s$, tal que: $ mu_pi (s) = lim_(t-->infinity) Pr{S_t = s | A_(0:t-1) tilde pi} $
]

// *****************************************************************************

#slide(title: [Retorno diferencial])[

  De esta forma, la calidad de una política $pi$ viene dada por la #stress[recompensa media por _timestep_] obtenida bajo esa política.

  #grayed[$ r(pi) &= lim_(h-->infinity) 1 / h sum^h_(t=1) EE[R_t | S_0, A_(0:t-1) tilde pi] $]

  - Toda política que maximice $r(pi)$ es una política óptima.

  - El #stress[retorno] pasa a denominarse #stress[retorno diferencial], y se define tal que:

  #grayed[$ G_t = R_(t+1) - r(pi) + R_(t+2) - r(pi) + R_(t+3) - r(pi) + dots $]

]

// *****************************************************************************

#slide(title: [Ejemplo])[

  #columns(2)[

    Volviendo al ejemplo anterior...

    #grayed[$ r(pi_"izq") = 1 / 5 = 0.2 $]

    #grayed[$ r(pi_"der") = 2 / 5 = 0.4 $]

    La recompensa media nos indica directamente qué política es mejor.

    #colbreak()

    #v(2cm)

    #figure(image("images/example.png"))
  ]
]

// *****************************************************************************

#slide(title: [Problema en aproximación de funciones])[

  #framed[
    ¿Por qué en problemas con aproximación de funciones es preferible la recompensa media al enfoque descontado?
  ]

  - En entornos descontados, es necesario definir un *factor de descuento $gamma$* ajustado de forma "manual".
  - En función del valor de $gamma$ elegido, nuestra representación/modelo de la función de valor $v, q$ puede variar significativamente. Esto hace que nuestra aproximación sea *inestable y dependiente de $gamma$*.
  - Si empleamos el *retorno diferencial*, contamos con *funciones de valor independientes de $gamma$* (solamente dependientes de la recompensa media).
  - El uso de la *recompensa media nos permite comparar políticas sin depender del valor de $gamma$*.

]


// // *****************************************************************************

// #slide(title: [Ejemplo])[

//     #columns(4)[

//       Siempre $pi_"izq"$:
//       $ G_t &= 1 - 0.2 + \
//             & 0 - 0.2 + \
//             & 0 - 0.2 + \
//             & 0 - 0.2 + \
//             & 0 - 0.2 + dots  = 0.4 \
//       $

//       #colbreak()

//       Siempre $pi_"der"$:
//       $ G_t &= 0 - 0.4 + \
//             & 0 - 0.4 + \
//             & 0 - 0.4 + \
//             & 0 - 0.4 + \
//             & 2 - 0.4 + dots  = -0.8 \
//       $

//       #colbreak()

//       $pi_"izq"$ y después $pi_"der"$ siempre:
//       $ G_t &= 1 - 0.4 + \
//             & 0 - 0.4 + \
//             & 0 - 0.4 + \
//             & 0 - 0.4 + \
//             & 0 - 0.4 + \
//             & -0.8 = -1.8 \
//       $

//       #colbreak()

//       $pi_"der"$ y después $pi_"izq"$ siempre:
//       $ G_t &= 0 - 0.2 + \
//             & 0 - 0.2 + \
//             & 0 - 0.2 + \
//             & 0 - 0.2 + \
//             & 2 - 0.2 + \
//             & 0.4= 1.4 \
//       $

//     ]

// ]

// *****************************************************************************

#slide(title: [Ecuaciones de Bellman con retorno diferencial])[

  Las #stress[ecuaciones de Bellman] con retorno diferencial se definen de la siguiente forma:

  #v(.4cm)

  $ v_pi (s) = sum_a pi(a|s) sum_(r,s') p(s',r|s,a) [r-r(pi) + v_pi (s')] $
  $ q_pi (s,a) = sum_(r,s') p(s',r|s,a) [r-r(pi) + sum_a' pi(a'|s') q_pi (s',a')] $
  $ v_* (s) = max_a sum_(r,s') p(s',r|s,a) [r-max_pi r(pi) + v_* (s')] $
  $ q_* (s,a) = sum_(r,s') p(s',r|s,a) [r-max_pi r(pi) + max_a' q_* (s',a')] $

]

// *****************************************************************************

#slide(title: [_TD-error_ con retorno diferencial])[

  También contamos con una definición de #stress[_TD-error_] empleando retorno diferencial:

  $ delta_t = R_(t+1) - overline(R)_t + hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t) $
  $ delta_t = R_(t+1) - overline(R)_t + hat(q)(S_(t+1), A_(t+1), bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t) $

  donde $overline(R)_t$ es la estimación en el instante $t$ de la recompensa media $r(pi)$.

  #framed[Empleando estas definiciones alternativas, los algoritmos vistos hasta el momento pueden adaptarse a la formulación de recompensa media sin apenas cambios.]

]

// *****************************************************************************

#slide(title: [SARSA diferencial semi-gradiente])[

  #figure(image("images/diff-sarsa.png"))

]

// *****************************************************************************

#slide(title: [_TD-error_ _n-step_ con retorno diferencial])[

  Dada la siguiente definición del #stress[retorno diferencial _n-step_]:

  $
    G_(t:t+n) = R_(t+1) + overline(R)_(t+n-1) + dots + R_(t+n) - overline(R)_(t+n-1) + hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1))
  $

  la versión #stress[_n-step_ del _TD-error_ diferencial] es:

  $ delta_t = G_(t:t+n) - hat(q) (S_t, A_t, bold(w)) $

  Esto nos permite formular la versión diferencial _n-step_ de SARSA semi-gradiente...

]


// *****************************************************************************

#slide(title: [SARSA _n-step_ diferencial semi-gradiente])[

  #figure(image("images/sarsa-diff-n.png"))

]

// *****************************************************************************

#title-slide("Trabajo propuesto")

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  #set text(size: 18pt)

  - Estudiar las #stress[implementaciones] de los algoritmos vistos.
    - #link("https://github.com/manjavacas/rl-temario/tree/main/ejemplos/value_approx/")
    - Impleméntalos por tu cuenta y aplícalos en otros problemas.
  - Lectura sobre #stress[_coarse coding_] y #stress[_tile coding_] (_ver Sutton & Barto sec. 9.5 & 9.6_ #text(size:18pt)[#emoji.books]).
  - Investiga sobre el algoritmo #stress[DQN] (Deep Q-Network).

  #text(size: 24pt)[*Bibliografía y recursos*]

  - *Capítulos 9 y 10* de Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction.
  - #link("https://youtu.be/Xg0WGzlEefY?si=r8Z2wrocsoHcyo7r")
  - #link("https://statquest.org/neural-networks-part-1-inside-the-black-box/")
  - #link("https://michaeloneill.github.io/RL-tutorial.html")
  - #link("https://www.davidsilver.uk/wp-content/uploads/2020/03/FA.pdf")
  - #link("https://www.youtube.com/watch?v=Vky0WVh_FSk")
]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Aproximación de funciones de valor",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)
