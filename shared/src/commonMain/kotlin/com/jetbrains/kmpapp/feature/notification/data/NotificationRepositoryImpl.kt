package com.jetbrains.kmpapp.feature.notification.data

import com.jetbrains.kmpapp.feature.notification.data.api.mapper.FirebasePipelineStatusMapper
import com.jetbrains.kmpapp.feature.notification.data.api.model.FirebasePipelineStatus
import com.jetbrains.kmpapp.feature.notification.domain.model.PipelineUpdate
import com.jetbrains.kmpapp.feature.notification.domain.NotificationRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

//internal class NotificationRepositoryImpl(
//    private val firestore: FirebaseFirestore = Firebase.firestore
//) : NotificationRepository {
//
//    private val firebasePipelineStatusMapper = FirebasePipelineStatusMapper()
//
//    override fun observePipelineUpdates(userId: String): Flow<List<PipelineUpdate>> {
//        return firestore
//            .collection("pipelineStatuses")
//            .where { "userId" equalTo userId }
//            .snapshots
//            .map { snapshot -> snapshot.toDomainList() }
//    }
//
//    private fun QuerySnapshot.toDomainList(): List<PipelineUpdate> =
//        documents.mapNotNull { doc -> doc.toDomainOrNull() }
//
//    private fun DocumentSnapshot.toDomainOrNull(): PipelineUpdate? =
//        runCatching {
//            val apiModel: FirebasePipelineStatus = data()
//            firebasePipelineStatusMapper.map(apiModel)
//        }.getOrNull()
//}
