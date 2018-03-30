include(clrfeatures.cmake)

# If set, indicates that this is not an officially supported release
# Keep in sync with IsPrerelease in dir.props
set(PRERELEASE 0)

# Features we're currently flighting, but don't intend to ship in officially supported releases
if (PRERELEASE)
  add_definitions(-DFEATURE_DEFAULT_INTERFACES=1)  
endif (PRERELEASE)

if (CLR_CMAKE_TARGET_ARCH_AMD64)
  if (CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DDBG_TARGET_AMD64_UNIX)
  endif()
  add_definitions(-D_TARGET_AMD64_=1)
  add_definitions(-D_TARGET_64BIT_=1)
  add_definitions(-DDBG_TARGET_64BIT=1)
  add_definitions(-DDBG_TARGET_AMD64=1)
  add_definitions(-DDBG_TARGET_WIN64=1)
elseif (CLR_CMAKE_TARGET_ARCH_ARM64)
  if (CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DDBG_TARGET_ARM64_UNIX)
  endif()
  add_definitions(-D_TARGET_ARM64_=1)
  add_definitions(-D_TARGET_64BIT_=1)
  add_definitions(-DDBG_TARGET_64BIT=1)
  add_definitions(-DDBG_TARGET_ARM64=1)
  add_definitions(-DDBG_TARGET_WIN64=1)
  add_definitions(-DFEATURE_MULTIREG_RETURN)
elseif (CLR_CMAKE_TARGET_ARCH_ARM)
  if (CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DDBG_TARGET_ARM_UNIX)
  elseif (WIN32 AND NOT DEFINED CLR_CROSS_COMPONENTS_BUILD)
    # Set this to ensure we can use Arm SDK for Desktop binary linkage when doing native (Arm32) build
    add_definitions(-D_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE=1)
    add_definitions(-D_ARM_WORKAROUND_)
  endif (CLR_CMAKE_PLATFORM_UNIX)
  add_definitions(-D_TARGET_ARM_=1)
  add_definitions(-DDBG_TARGET_32BIT=1)
  add_definitions(-DDBG_TARGET_ARM=1)
elseif (CLR_CMAKE_TARGET_ARCH_I386)
  add_definitions(-D_TARGET_X86_=1)
  add_definitions(-DDBG_TARGET_32BIT=1)
  add_definitions(-DDBG_TARGET_X86=1)
else ()
  clr_unknown_arch()
endif (CLR_CMAKE_TARGET_ARCH_AMD64)

if (CLR_CMAKE_PLATFORM_UNIX)

  if(CLR_CMAKE_PLATFORM_DARWIN)
    add_definitions(-D_XOPEN_SOURCE)
    add_definitions(-DFEATURE_DATATARGET4)
  endif(CLR_CMAKE_PLATFORM_DARWIN)

  if (CLR_CMAKE_TARGET_ARCH_AMD64)
    add_definitions(-DUNIX_AMD64_ABI)
  elseif (CLR_CMAKE_TARGET_ARCH_ARM)
    add_definitions(-DUNIX_ARM_ABI)
    add_definitions(-DFEATURE_DATATARGET4)
  elseif (CLR_CMAKE_TARGET_ARCH_I386)
    add_definitions(-DUNIX_X86_ABI)
  endif()

endif(CLR_CMAKE_PLATFORM_UNIX)

if(CLR_CMAKE_PLATFORM_ALPINE_LINUX)
  # Alpine Linux doesn't have fixed stack limit, this define disables some stack pointer
  # sanity checks in debug / checked build that rely on a fixed stack limit
  add_definitions(-DNO_FIXED_STACK_LIMIT)
endif(CLR_CMAKE_PLATFORM_ALPINE_LINUX)

add_definitions(-D_BLD_CLR)
add_definitions(-DDEBUGGING_SUPPORTED)
add_definitions(-DPROFILING_SUPPORTED)

if(WIN32)
  add_definitions(-DWIN32)
  add_definitions(-D_WIN32)
  add_definitions(-DWINVER=0x0602)
  add_definitions(-D_WIN32_WINNT=0x0602)
  add_definitions(-DWIN32_LEAN_AND_MEAN=1)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
  if(CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386)
    # Only enable edit and continue on windows x86 and x64
    # exclude Linux, arm & arm64
    add_definitions(-DEnC_SUPPORTED)
  endif(CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386)
endif(WIN32)

# Features - please keep them alphabetically sorted
if (FEATURE_APPDOMAIN_RESOURCE_MONITORING)
  add_definitions(-DFEATURE_APPDOMAIN_RESOURCE_MONITORING)
endif(FEATURE_APPDOMAIN_RESOURCE_MONITORING)

if(WIN32)
  add_definitions(-DFEATURE_APPX)
  if(NOT CLR_CMAKE_TARGET_ARCH_I386)
    add_definitions(-DFEATURE_ARRAYSTUB_AS_IL)
    add_definitions(-DFEATURE_MULTICASTSTUB_AS_IL)
  endif()
else(WIN32)
  add_definitions(-DFEATURE_ARRAYSTUB_AS_IL)
  add_definitions(-DFEATURE_MULTICASTSTUB_AS_IL)
endif(WIN32)
add_definitions(-DFEATURE_CODE_VERSIONING)
add_definitions(-DFEATURE_COLLECTIBLE_TYPES)

if(WIN32)
    add_definitions(-DFEATURE_CLASSIC_COMINTEROP)
    add_definitions(-DFEATURE_COMINTEROP)
    add_definitions(-DFEATURE_COMINTEROP_APARTMENT_SUPPORT)
    add_definitions(-DFEATURE_COMINTEROP_UNMANAGED_ACTIVATION)
    add_definitions(-DFEATURE_COMINTEROP_WINRT_MANAGED_ACTIVATION)
endif(WIN32)

add_definitions(-DFEATURE_CORECLR)
if (CLR_CMAKE_PLATFORM_UNIX)
  add_definitions(-DFEATURE_COREFX_GLOBALIZATION)
endif(CLR_CMAKE_PLATFORM_UNIX)
add_definitions(-DFEATURE_CORESYSTEM)
add_definitions(-DFEATURE_CORRUPTING_EXCEPTIONS)
if(FEATURE_DBGIPC)
  add_definitions(-DFEATURE_DBGIPC_TRANSPORT_DI)
  add_definitions(-DFEATURE_DBGIPC_TRANSPORT_VM)
endif(FEATURE_DBGIPC)
if(FEATURE_EVENT_TRACE)
    add_definitions(-DFEATURE_EVENT_TRACE=1)
    add_definitions(-DFEATURE_PERFTRACING=1)
endif(FEATURE_EVENT_TRACE)
if(FEATURE_GDBJIT)
    add_definitions(-DFEATURE_GDBJIT)
endif()
if(FEATURE_GDBJIT_FRAME)
    add_definitions(-DFEATURE_GDBJIT_FRAME)
endif(FEATURE_GDBJIT_FRAME)
if(FEATURE_GDBJIT_LANGID_CS)
    add_definitions(-DFEATURE_GDBJIT_LANGID_CS)
endif(FEATURE_GDBJIT_LANGID_CS)
if(FEATURE_GDBJIT_SYMTAB)
    add_definitions(-DFEATURE_GDBJIT_SYMTAB)
endif(FEATURE_GDBJIT_SYMTAB)
if(CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DFEATURE_EVENTSOURCE_XPLAT=1)
endif(CLR_CMAKE_PLATFORM_UNIX)
# NetBSD doesn't implement this feature
if(NOT CMAKE_SYSTEM_NAME STREQUAL NetBSD)
    add_definitions(-DFEATURE_HIJACK)
endif(NOT CMAKE_SYSTEM_NAME STREQUAL NetBSD)
add_definitions(-DFEATURE_ICASTABLE)
if (WIN32 AND (CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386))
    add_definitions(-DFEATURE_INTEROP_DEBUGGING)
endif (WIN32 AND (CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386))
if(FEATURE_INTERPRETER)
  add_definitions(-DFEATURE_INTERPRETER)
endif(FEATURE_INTERPRETER)
add_definitions(-DFEATURE_ISYM_READER)
if(CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386)
    add_definitions(-DFEATURE_JUMPSTAMP)
  endif(CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386)
add_definitions(-DFEATURE_LOADER_OPTIMIZATION)
if (CLR_CMAKE_PLATFORM_LINUX OR WIN32)
    add_definitions(-DFEATURE_MANAGED_ETW)
endif(CLR_CMAKE_PLATFORM_LINUX OR WIN32)
add_definitions(-DFEATURE_MANAGED_ETW_CHANNELS)

if(FEATURE_MERGE_JIT_AND_ENGINE)
  add_definitions(-DFEATURE_MERGE_JIT_AND_ENGINE)
endif(FEATURE_MERGE_JIT_AND_ENGINE)
add_definitions(-DFEATURE_MULTICOREJIT)
if (FEATURE_NI_BIND_FALLBACK)
  add_definitions(-DFEATURE_NI_BIND_FALLBACK)
endif(FEATURE_NI_BIND_FALLBACK)
if(CLR_CMAKE_PLATFORM_UNIX)
  add_definitions(-DFEATURE_PAL)
  add_definitions(-DFEATURE_PAL_SXS)
  add_definitions(-DFEATURE_PAL_ANSI)
endif(CLR_CMAKE_PLATFORM_UNIX)
if(CLR_CMAKE_PLATFORM_LINUX)
    add_definitions(-DFEATURE_PERFMAP)
endif(CLR_CMAKE_PLATFORM_LINUX)
add_definitions(-DFEATURE_PREJIT)

add_definitions(-DFEATURE_READYTORUN)
set(FEATURE_READYTORUN 1)

if (CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386)
  add_definitions(-DFEATURE_REJIT)
endif(CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386)

add_definitions(-DFEATURE_STANDALONE_SN)
add_definitions(-DFEATURE_STRONGNAME_DELAY_SIGNING_ALLOWED)
add_definitions(-DFEATURE_STRONGNAME_MIGRATION)
if (CLR_CMAKE_PLATFORM_UNIX OR CLR_CMAKE_TARGET_ARCH_ARM64)
    add_definitions(-DFEATURE_STUBS_AS_IL)
endif ()
add_definitions(-DFEATURE_SVR_GC)
add_definitions(-DFEATURE_SYMDIFF)
add_definitions(-DFEATURE_TIERED_COMPILATION)
if (CLR_CMAKE_PLATFORM_ARCH_AMD64)
  # Enable the AMD64 Unix struct passing JIT-EE interface for all AMD64 platforms, to enable altjit.
  add_definitions(-DFEATURE_UNIX_AMD64_STRUCT_PASSING_ITF)
endif (CLR_CMAKE_PLATFORM_ARCH_AMD64)
if(CLR_CMAKE_PLATFORM_UNIX_AMD64)
  add_definitions(-DFEATURE_MULTIREG_RETURN)
endif (CLR_CMAKE_PLATFORM_UNIX_AMD64)
if(CLR_CMAKE_PLATFORM_UNIX AND CLR_CMAKE_TARGET_ARCH_AMD64)
  add_definitions(-DFEATURE_UNIX_AMD64_STRUCT_PASSING)
endif(CLR_CMAKE_PLATFORM_UNIX AND CLR_CMAKE_TARGET_ARCH_AMD64)
add_definitions(-DFEATURE_USE_ASM_GC_WRITE_BARRIERS)
if(CLR_CMAKE_PLATFORM_ARCH_AMD64 OR (CLR_CMAKE_PLATFORM_ARCH_ARM64 AND NOT WIN32))
  add_definitions(-DFEATURE_USE_SOFTWARE_WRITE_WATCH_FOR_GC_HEAP)
endif(CLR_CMAKE_PLATFORM_ARCH_AMD64 OR (CLR_CMAKE_PLATFORM_ARCH_ARM64 AND NOT WIN32))
if((CLR_CMAKE_PLATFORM_ARCH_AMD64 OR CLR_CMAKE_PLATFORM_ARCH_ARM64) AND NOT WIN32)
  add_definitions(-DFEATURE_MANUALLY_MANAGED_CARD_BUNDLES)
endif((CLR_CMAKE_PLATFORM_ARCH_AMD64 OR CLR_CMAKE_PLATFORM_ARCH_ARM64) AND NOT WIN32)

if(WIN32)
    add_definitions(-DFEATURE_VERSIONING_LOG)
endif(WIN32)
if(NOT CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DFEATURE_WIN32_REGISTRY)
endif(NOT CLR_CMAKE_PLATFORM_UNIX)
add_definitions(-DFEATURE_LEGACYNETCF_DBG_HOST_CONTROL)
add_definitions(-DFEATURE_WINDOWSPHONE)
add_definitions(-DFEATURE_WINMD_RESILIENT)
add_definitions(-D_SECURE_SCL=0)
add_definitions(-DUNICODE)
add_definitions(-D_UNICODE)
