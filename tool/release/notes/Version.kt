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

data class Version(val major: Int, val minor: Int, val patch: Int, val alpha: Int?): Comparable<Version> {
    companion object {
        fun parse(version: String): Version {
            val version1 = version.split("-")
            require(version1.isNotEmpty() && version1.size <= 3) {
                "version '$version1' does not follow the form 'x.y.z', 'x.y.z-alpha', or 'x.y.z-alpha-n'"
            }
            val version2 = version1[0].split(".")
            if (version1.size == 1) {
                require(version2.size == 3) { "version must be of the form x.y.z" }
                return Version(
                    major = version2[0].toInt(),
                    minor = version2[1].toInt(),
                    patch = version2[2].toInt(),
                    alpha = null
                )
            } else if (version1.size == 2) {
                return Version(
                    major = version2[0].toInt(),
                    minor = version2[1].toInt(),
                    patch = version2[2].toInt(),
                    alpha = 1
                )
            } else {
                return Version(
                    major = version2[0].toInt(),
                    minor = version2[1].toInt(),
                    patch = version2[2].toInt(),
                    alpha = version1[2].toInt()
                )
            }
        }
    }

    override fun compareTo(other: Version): Int {
        val major = major.compareTo(other.major)
        if (major == 0) {
            val minor = minor.compareTo(other.minor)
            if (minor == 0) {
                val patch = patch.compareTo(other.patch)
                if (patch == 0) {
                    if (alpha == null) {
                        if (other.alpha == null) return 0
                        else return 1
                    } else {
                        if (other.alpha != null) return alpha.compareTo(other.alpha)
                        else return -1
                    }
                } else return patch
            } else return minor
        } else return major
    }

    override fun toString(): String {
        val alpha =
            if (alpha != null) {
                if (alpha == 1) "-alpha"
                else "-alpha-$alpha"
            } else ""
        return "$major.$minor.$patch$alpha"
    }
}
