/*
 * Copyright (C) 2022 Vaticle
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package com.vaticle.dependencies.tool.release.notes

data class Version(val major: Int, val minor: Int, val patch: Int, val rc: Int?, val alpha: Int?): Comparable<Version> {
    companion object {
        fun parse(version: String): Version {
            val components = version.split("-")
            val (major, minor, patch) = components[0].split(".").map(String::toInt)
            return when (components.size) {
                1 -> Version(major = major, minor = minor, patch = patch, rc = null, alpha = null)
                2 -> when {
                    components[1] == "alpha" -> Version(major = major, minor = minor, patch = patch, rc = null, alpha = 1)
                    components[1].startsWith("rc") -> Version(
                        major = major,
                        minor = minor,
                        patch = patch,
                        rc = components[1].removePrefix("rc").toInt(),
                        alpha = null
                    )
                    else -> {
                        throw IllegalArgumentException(
                            "version '$version' does not follow the form 'x.y.z', 'x.y.z-rcN', 'x.y.z-alpha', or 'x.y.z-alpha-N'"
                        )
                    }
                }
                3 -> {
                    require(components[1] == "alpha") {
                        "version '$version' does not follow the form 'x.y.z', 'x.y.z-rcN', 'x.y.z-alpha', or 'x.y.z-alpha-N'"
                    }
                    Version(major = major, minor = minor, patch = patch, rc = null, alpha = components[2].toInt())
                }
                else -> {
                    throw IllegalArgumentException(
                        "version '$version' does not follow the form 'x.y.z', 'x.y.z-rcN', 'x.y.z-alpha', or 'x.y.z-alpha-N'"
                    ) 
                }
            }
        }
    }

    override fun compareTo(other: Version): Int {
        val major = major.compareTo(other.major)
        if (major != 0) return major

        val minor = minor.compareTo(other.minor)
        if (minor != 0) return minor

        val patch = patch.compareTo(other.patch)
        if (patch != 0) return patch

        if (rc != null) {
            if (other.rc != null) return rc.compareTo(other.rc)
            else if (other.alpha != null) return 1
            else return -1
        }

        if (alpha != null) {
            if (other.alpha != null) return alpha.compareTo(other.alpha)
            else return -1
        }

        return 1 // x.y.z is always after x.y.z-prereleases
    }

    override fun toString(): String {
        val prerelease = when {
            rc != null -> "-rc$rc"
            alpha == 1 -> "-alpha"
            alpha != null -> "-alpha-$alpha"
            else -> ""
        }
        return "$major.$minor.$patch$prerelease"
    }

    fun isPrerelease(): Boolean = rc != null || alpha != null
}
