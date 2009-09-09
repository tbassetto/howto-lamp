.. include:: substitutions.inc
.. index:: BNF, grammar, syntax, notation
.. highlight:: php
   :linenothreshold: 1

Annexe : Bac à sable (test de reST)
===================================

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Et ceci est une subsection
**************************

|today|

|apache|

Lorem ipsum [Ref]_ dolor sit amet.

.. [Ref] Book or article reference, URL or whatever.

Une autre subsection : références
*********************************

Lorem ipsum [#f1]_ dolor sit amet ... [#f2]_

Notes
-----

.. note::

   This function is not suitable for sending spam e-mails.

Warnings
--------


.. warning::

   This function is not suitable for sending spam e-mails.

Voire aussi
-----------


.. seealso::

   Module :mod:`zipfile`
      Documentation of the :mod:`zipfile` standard module.

   `GNU tar manual, Basic Tar Format <http://link>`_
      Documentation for tar archive files, including GNU tar extensions.

Centré (centered)
------------------

.. centered:: LICENSE AGREEMENT

Liste mais horizontale autant que possible
------------------------------------------

.. hlist::
   :columns: 3

   * A list of
   * short items
   * that should be
   * displayed
   * horizontally

Référence vers un titre plus bas, see :ref:`my-reference-label`.

.. note::
	
	Using ref is advised over standard reStructuredText links to sections (like ```Section title`_)`` because it works across files, when section headings are changed, and for all builders that support cross-references.
	
Mais on peut faire plus fort, lien vers un document en particulier : :doc:`apache`.

Une référence vers une section particulière du chapitre apache : Référence vers un titre plus bas, see :ref:`my-label-de-test`.

Mieux que les ` pour les commandes Unix, l'utilisation de ``:command:`` : :command:`apt-get install apache`.

It is installed in :file:`/usr/lib/python2/site-packages` !

Raccourcis-clavier : :kbd:`Control-x Control-f`.

Citation pour le nom d'un logiciel : :program:`Apache`.

Version de ce document : |release|.

Local TOC
---------

.. contents::

.. _my-reference-label:

Et une dernière subsubsection !
-------------------------------

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum:: 

	<?php
	echo "Hello World";
	?>

Test d'image :

.. _label-de-la-figure:

.. image:: _static/army.jpg

.. rubric:: Footnotes

.. [#f1] Text of the first footnote.
.. [#f2] Text of the second footnote.