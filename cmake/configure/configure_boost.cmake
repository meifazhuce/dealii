## ---------------------------------------------------------------------
##
## Copyright (C) 2012 - 2015 by the deal.II authors
##
## This file is part of the deal.II library.
##
## The deal.II library is free software; you can use it, redistribute
## it, and/or modify it under the terms of the GNU Lesser General
## Public License as published by the Free Software Foundation; either
## version 2.1 of the License, or (at your option) any later version.
## The full text of the license can be found in the file LICENSE at
## the top level of the deal.II distribution.
##
## ---------------------------------------------------------------------

#
# Configuration for the boost library:
#

SET(DEAL_II_WITH_BOOST ON # Always true. We need it :-]
  CACHE BOOL "Build deal.II with support for boost." FORCE
  )


MACRO(SET_UP_BOOST_FLAGS)
  #
  # Newer versions of gcc have a flag -Wunused-local-typedefs that, though in
  # principle a good idea, triggers a lot in BOOST in various places.
  # Unfortunately, this warning is included in -W/-Wall, so disable it if the
  # compiler supports it.
  #
  ENABLE_IF_SUPPORTED(BOOST_CXX_FLAGS "-Wno-unused-local-typedefs")

  IF(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    # not harmless but needed for boost <1.50.0
    ENABLE_IF_SUPPORTED(BOOST_CXX_FLAGS "-Wno-delete-non-virtual-dtor")

    # suppress warnings in boost 1.56:
    ENABLE_IF_SUPPORTED(BOOST_CXX_FLAGS "-Wno-c++11-extensions")
    ENABLE_IF_SUPPORTED(BOOST_CXX_FLAGS "-Wno-c99-extensions")
    ENABLE_IF_SUPPORTED(BOOST_CXX_FLAGS "-Wno-unused-parameter")
    ENABLE_IF_SUPPORTED(BOOST_CXX_FLAGS "-Wno-variadic-macros")
  ENDIF()
ENDMACRO()


MACRO(FEATURE_BOOST_CONFIGURE_BUNDLED)
  #
  # Add rt to the link interface as well, boost/chrono needs it.
  #
  FIND_SYSTEM_LIBRARY(rt_LIBRARY NAMES rt)
  MARK_AS_ADVANCED(rt_LIBRARY)
  IF(NOT rt_LIBRARY MATCHES "-NOTFOUND")
    SET(BOOST_LIBRARIES ${rt_LIBRARY})
  ENDIF()

  SET_UP_BOOST_FLAGS()

  SET(BOOST_BUNDLED_INCLUDE_DIRS ${BOOST_FOLDER}/include)
ENDMACRO()


MACRO(FEATURE_BOOST_CONFIGURE_EXTERNAL)
  SET_UP_BOOST_FLAGS()
ENDMACRO()


CONFIGURE_FEATURE(BOOST)


#
# DEAL_II_WITH_BOOST is always required.
#
IF(NOT DEAL_II_WITH_BOOST)
  IF(DEAL_II_FEATURE_AUTODETECTION)
    FEATURE_ERROR_MESSAGE("BOOST")
  ELSE()
    MESSAGE(FATAL_ERROR "\n"
      "Unmet configuration requirements: "
      "DEAL_II_WITH_BOOST required, but set to OFF!.\n\n"
      )
  ENDIF()
ENDIF()
